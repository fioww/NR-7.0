package com.company.assembleegameclient.ui.menu
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.ui.GameObjectListItem;
   import com.company.assembleegameclient.util.GuildUtil;
   import com.company.util.AssetLibrary;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class PlayerMenu extends Menu
   {
       
      
      public var gs_:GameSprite;
      
      public var playerName_:String;
      
      public var player_:Player;
      
      public var playerPanel_:GameObjectListItem;
      
      public function PlayerMenu(gs:GameSprite, player:Player)
      {
         var option:MenuOption = null;
         super(3552822,16777215);
         this.gs_ = gs;
         this.playerName_ = player.name_;
         this.player_ = player;
         this.playerPanel_ = new GameObjectListItem(11776947,true,this.player_);
         addChild(this.playerPanel_);
         if(this.gs_.map.allowPlayerTeleport_ && this.player_.isTeleportEligible(this.player_))
         {
            option = new TeleportMenuOption(this.gs_.map.player_);
            option.addEventListener(MouseEvent.CLICK,this.onTeleport);
            addOption(option);
         }
         if(this.gs_.map.player_.guildRank_ >= GuildUtil.OFFICER && (player.guildName_ == null || player.guildName_.length == 0))
         {
            option = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig",10),16777215,"Invite");
            option.addEventListener(MouseEvent.CLICK,this.onInvite);
            addOption(option);
         }
         if(!this.player_.starred_)
         {
            option = new MenuOption(AssetLibrary.getImageFromSet("lofiInterface2",5),16777215,"Lock");
            option.addEventListener(MouseEvent.CLICK,this.onLock);
            addOption(option);
         }
         else
         {
            option = new MenuOption(AssetLibrary.getImageFromSet("lofiInterface2",6),16777215,"Unlock");
            option.addEventListener(MouseEvent.CLICK,this.onUnlock);
            addOption(option);
         }
         option = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig",7),16777215,"Trade");
         option.addEventListener(MouseEvent.CLICK,this.onTrade);
         addOption(option);
         if(!this.player_.ignored_)
         {
            option = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig",8),16777215,"Ignore");
            option.addEventListener(MouseEvent.CLICK,this.onIgnore);
            addOption(option);
         }
         else
         {
            option = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig",9),16777215,"Unignore");
            option.addEventListener(MouseEvent.CLICK,this.onUnignore);
            addOption(option);
         }
         if (Player.isAdmin)
         {
            option = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig", 10), 0xFFFFFF, "Ban RWT");
            option.addEventListener(MouseEvent.CLICK, this.onBanRWT);
            addOption(option);
            option = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig", 10), 0xFFFFFF, "Ban Cheat");
            option.addEventListener(MouseEvent.CLICK, this.onBanCheat);
            addOption(option);
            option = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig", 4), 0xFFFFFF, "Mute");
            option.addEventListener(MouseEvent.CLICK, this.onMute);
            addOption(option);
            option = new MenuOption(AssetLibrary.getImageFromSet("lofiInterfaceBig", 3), 0xFFFFFF, "UnMute");
            option.addEventListener(MouseEvent.CLICK, this.onUnMute);
            addOption(option);
         }
      }

      private function onBanRWT(event:Event):void {
         this.gs_.gsc_.playerText((("/banip " + this.player_.name_) + " RWT"));
         remove();
      }

      private function onBanCheat(event:Event):void {
         this.gs_.gsc_.playerText((("/banip " + this.player_.name_) + " Cheating"));
         remove();
      }

      private function onMute(event:Event):void {
         this.gs_.gsc_.playerText(("/mute " + this.player_.name_));
         remove();
      }

      private function onUnMute(event:Event):void {
         this.gs_.gsc_.playerText(("/unmute " + this.player_.name_));
         remove();
      }
      
      private function onTeleport(event:Event) : void
      {
         this.gs_.map.player_.teleportTo(this.player_);
         remove();
      }
      
      private function onInvite(event:Event) : void
      {
         this.gs_.gsc_.guildInvite(this.playerName_);
         remove();
      }
      
      private function onLock(event:Event) : void
      {
         this.gs_.map.party_.lockPlayer(this.player_);
         remove();
      }
      
      private function onUnlock(event:Event) : void
      {
         this.gs_.map.party_.unlockPlayer(this.player_);
         remove();
      }
      
      private function onTrade(event:Event) : void
      {
         this.gs_.gsc_.requestTrade(this.playerName_);
         remove();
      }
      
      private function onIgnore(event:Event) : void
      {
         this.gs_.map.party_.ignorePlayer(this.player_);
         remove();
      }
      
      private function onUnignore(event:Event) : void
      {
         this.gs_.map.party_.unignorePlayer(this.player_);
         remove();
      }
   }
}
