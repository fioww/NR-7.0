using NLog;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace common.resources
{
    public class Resources : IDisposable
    {
        static readonly Logger Log = LogManager.GetCurrentClassLogger();

        public string ResourcePath { get; private set; }
        public XmlData GameData { get; private set; }
        public IDictionary<string, byte[]> WebFiles { get; private set; }
        public WorldData Worlds { get; private set; }
        public AppSettings Settings { get; private set; }
        public IList<string> MusicNames { get; private set; }

        public Resources(string resourcePath, bool wServer = false)
        {
            Log.Info("Loading resources...");
            ResourcePath = resourcePath;
            GameData = new XmlData(resourcePath + "/xml");
            Settings = new AppSettings(resourcePath + "/data/init.xml");

            if (!wServer)
            {
                webFiles(resourcePath + "/web");
            }
            else
            {
                Worlds = new WorldData(resourcePath + "/worlds", GameData);
            }

            music(resourcePath);
        }

        private void webFiles(string dir)
        {
            Log.Info("Loading web data...");

            Dictionary<string, byte[]> webFiles;

            WebFiles =
                new ReadOnlyDictionary<string, byte[]>(
                    webFiles = new Dictionary<string, byte[]>());

            var files = Directory.EnumerateFiles(dir, "*", SearchOption.AllDirectories);
            foreach (var file in files)
            {
                var webPath = file.Substring(dir.Length, file.Length - dir.Length)
                    .Replace("\\", "/");

                webFiles[webPath] = File.ReadAllBytes(file);
            }
        }

        private void music(string baseDir)
        {
            List<string> music;

            MusicNames =
                new ReadOnlyCollection<string>(
                    music = new List<string>());

            music.AddRange(Directory
                .EnumerateFiles(baseDir + "/web/music", "*.mp3", SearchOption.AllDirectories)
                .Select(Path.GetFileNameWithoutExtension));
        }

        public void Dispose()
        {

        }
    }
}
