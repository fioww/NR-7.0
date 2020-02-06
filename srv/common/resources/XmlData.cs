using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.IO;
using System.Linq;
using System.Xml.Linq;
using System.Xml.XPath;
using NLog;

namespace common.resources
{
    public class XmlData : IDisposable
    {
        static readonly Logger Log = LogManager.GetCurrentClassLogger();

        private readonly List<string> _gameXmls;
        public IList<string> GameXmls { get; private set; }

        private readonly List<string[]> _usedRemoteTextures;
        public IList<string[]> UsedRemoteTextures { get; private set; }

        public byte[] ZippedXmls { get; private set; }

        Dictionary<ushort, XElement> type2elem_obj;
        Dictionary<ushort, string> type2id_obj;
        Dictionary<string, ushort> id2type_obj;
        Dictionary<string, ushort> d_name2type_obj;
        Dictionary<ushort, XElement> type2elem_tile;
        Dictionary<ushort, string> type2id_tile;
        Dictionary<string, ushort> id2type_tile;
        Dictionary<ushort, TileDesc> tiles;
        Dictionary<ushort, Item> items;
        Dictionary<ushort, ObjectDesc> objDescs;
        Dictionary<ushort, PortalDesc> portals;
        Dictionary<ushort, SkinDesc> skins;
        Dictionary<ushort, PlayerDesc> classes;
        Dictionary<ushort, ObjectDesc> merchants;
        Dictionary<int, ItemType> slotType2ItemType;

        public IDictionary<ushort, XElement> ObjectTypeToElement { get; private set; }
        public IDictionary<ushort, string> ObjectTypeToId { get; private set; }
        public IDictionary<string, ushort> IdToObjectType { get; private set; }
        public IDictionary<string, ushort> DisplayIdToObjectType { get; private set; }
        public IDictionary<ushort, XElement> TileTypeToElement { get; private set; }
        public IDictionary<ushort, string> TileTypeToId { get; private set; }
        public IDictionary<string, ushort> IdToTileType { get; private set; }
        public IDictionary<ushort, TileDesc> Tiles { get; private set; }
        public IDictionary<ushort, Item> Items { get; private set; }
        public IDictionary<ushort, ObjectDesc> ObjectDescs { get; private set; }
        public IDictionary<ushort, PortalDesc> Portals { get; private set; }
        public IDictionary<ushort, SkinDesc> Skins { get; private set; }
        public IDictionary<ushort, PlayerDesc> Classes { get; private set; }
        public IDictionary<ushort, ObjectDesc> Merchants { get; private set; }
        public IDictionary<int, ItemType> SlotType2ItemType { get; private set; }

        int updateCount = 0;
        int prevUpdateCount = -1;

        public XmlData(string path)
        {
            Log.Info("Loading xml data...");

            GameXmls =
                new ReadOnlyCollection<string>(
                    _gameXmls = new List<string>());

            UsedRemoteTextures =
                new ReadOnlyCollection<string[]>(
                    _usedRemoteTextures = new List<string[]>());

            ObjectTypeToElement =
                new ReadOnlyDictionary<ushort, XElement>(
                    type2elem_obj = new Dictionary<ushort, XElement>());
            ObjectTypeToId =
                new ReadOnlyDictionary<ushort, string>(
                    type2id_obj = new Dictionary<ushort, string>());
            IdToObjectType =
                new ReadOnlyDictionary<string, ushort>(
                    id2type_obj = new Dictionary<string, ushort>(StringComparer.InvariantCultureIgnoreCase));
            DisplayIdToObjectType =
                new ReadOnlyDictionary<string, ushort>(
                    d_name2type_obj = new Dictionary<string, ushort>(StringComparer.InvariantCultureIgnoreCase));
            TileTypeToElement =
                new ReadOnlyDictionary<ushort, XElement>(
                    type2elem_tile = new Dictionary<ushort, XElement>());
            TileTypeToId =
                new ReadOnlyDictionary<ushort, string>(
                    type2id_tile = new Dictionary<ushort, string>());
            IdToTileType =
                new ReadOnlyDictionary<string, ushort>(
                    id2type_tile = new Dictionary<string, ushort>(StringComparer.InvariantCultureIgnoreCase));
            Tiles =
                new ReadOnlyDictionary<ushort, TileDesc>(
                    tiles = new Dictionary<ushort, TileDesc>());
            Items =
                new ReadOnlyDictionary<ushort, Item>(
                    items = new Dictionary<ushort, Item>());
            ObjectDescs =
                new ReadOnlyDictionary<ushort, ObjectDesc>(
                    objDescs = new Dictionary<ushort, ObjectDesc>());
            Portals =
                new ReadOnlyDictionary<ushort, PortalDesc>(
                    portals = new Dictionary<ushort, PortalDesc>());
            Skins =
                new ReadOnlyDictionary<ushort, SkinDesc>(
                    skins = new Dictionary<ushort, SkinDesc>());
            Classes =
                new ReadOnlyDictionary<ushort, PlayerDesc>(
                    classes = new Dictionary<ushort, PlayerDesc>());
            Merchants =
                new ReadOnlyDictionary<ushort, ObjectDesc>(
                    merchants = new Dictionary<ushort, ObjectDesc>());
            SlotType2ItemType =
                new ReadOnlyDictionary<int, ItemType>(
                    slotType2ItemType = new Dictionary<int, ItemType>());

            string basePath = Utils.GetBasePath(path);

            // load additional xmls into GameXmls string array
            LoadXmls(basePath, "*.xml");

            // add embedded client xmls to GameXmls string array
            LoadXmls(basePath, "*.dat");

            Log.Info("Finish loading game data.");
            Log.Info("{0} Items", items.Count);
            Log.Info("{0} Tiles", tiles.Count);
            Log.Info("{0} Objects", objDescs.Count);
            Log.Info("{0} Skins", skins.Count);
            Log.Info("{0} Classes", classes.Count);
            Log.Info("{0} Portals", portals.Count);
            Log.Info("{0} Merchants", merchants.Count);
        }

        private void LoadXmls(string basePath, string ext)
        {
            var xmls = Directory.EnumerateFiles(basePath, ext, SearchOption.AllDirectories).ToArray();
            for (var i = 0; i < xmls.Length; i++)
            {
                //log.InfoFormat("Loading '{0}'({1}/{2})...", xmls[i], i + 1, xmls.Length);
                var xml = File.ReadAllText(xmls[i]);
                _gameXmls.Add(xml);
                ProcessXml(XElement.Parse(xml));
            }
        }

        private void AddObjects(XElement root)
        {
            foreach (var elem in root.XPathSelectElements("//Object"))
            {
                if (elem.Element("Class") == null)
                    continue;

                var cls = elem.Element("Class").Value;
                var id = elem.Attribute("id").Value;

                ushort type;
                var typeAttr = elem.Attribute("type");
                if (typeAttr == null)
                {
                    Log.Error($"{id} is missing type number. Skipped.");
                    continue;
                }
                type = (ushort)Utils.FromString(typeAttr.Value);

                if (type2id_obj.ContainsKey(type))
                    Log.Warn("'{0}' and '{1}' has the same ID of 0x{2:x4}!", id, type2id_obj[type], type);
                else
                {
                    type2id_obj[type] = id;
                    type2elem_obj[type] = elem;
                }

                if (id2type_obj.ContainsKey(id))
                    Log.Warn("0x{0:x4} and 0x{1:x4} has the same name of {2}!", type, id2type_obj[id], id);
                else
                    id2type_obj[id] = type;

                var displayId = elem.Element("DisplayId") != null ? elem.Element("DisplayId").Value : null;

                string displayName;

                if (displayId == null)
                {
                    displayName = id;
                }
                else
                {
                    if (displayId[0].Equals('{'))
                    {
                        displayName = id;
                    }
                    else
                    {
                        displayName = displayId;
                    }
                }

                d_name2type_obj[displayName] = type;

                switch (cls)
                {
                    case "Equipment":
                    case "Dye":
                        items[type] = new Item(type, elem);
                        break;
                    case "Player":
                        var pDesc = new PlayerDesc(type, elem);
                        slotType2ItemType[pDesc.SlotTypes[0]] = ItemType.Weapon;
                        slotType2ItemType[pDesc.SlotTypes[1]] = ItemType.Ability;
                        slotType2ItemType[pDesc.SlotTypes[2]] = ItemType.Armor;
                        slotType2ItemType[pDesc.SlotTypes[3]] = ItemType.Ring;
                        classes[type] = new PlayerDesc(type, elem);
                        objDescs[type] = classes[type];
                        break;
                    case "Portal":
                        portals[type] = new PortalDesc(type, elem);
                        objDescs[type] = portals[type];
                        break;
                    case "GuildMerchant":
                    case "Merchant":
                        merchants[type] = new ObjectDesc(type, elem);
                        break;
                    default:
                        objDescs[type] = new ObjectDesc(type, elem);
                        break;
                }
            }
        }

        private void AddGrounds(XElement root)
        {
            foreach (var elem in root.XPathSelectElements("//Ground"))
            {
                string id = elem.Attribute("id").Value;

                ushort type;
                var typeAttr = elem.Attribute("type");
                type = (ushort)Utils.FromString(typeAttr.Value);

                if (type2id_tile.ContainsKey(type))
                    Log.Warn("'{0}' and '{1}' has the same ID of 0x{2:x4}!", id, type2id_tile[type], type);
                if (id2type_tile.ContainsKey(id))
                    Log.Warn("0x{0:x4} and 0x{1:x4} has the same name of {2}!", type, id2type_tile[id], id);

                type2id_tile[type] = id;
                id2type_tile[id] = type;
                type2elem_tile[type] = elem;

                tiles[type] = new TileDesc(type, elem);
            }
        }

        private void ProcessXml(XElement root)
        {
            AddObjects(root);
            AddGrounds(root);
        }

        public void Dispose()
        {
        }
    }
}