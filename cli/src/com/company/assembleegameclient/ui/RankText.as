package com.company.assembleegameclient.ui
{
   import com.company.assembleegameclient.util.FameUtil;
   import com.company.ui.SimpleText;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   
   public class RankText extends Sprite
   {
       
      
      public var sprite_:Sprite = null;
      
      public var largeText_:Boolean;
      
      private var numStars_:int = -1;

      private var rank_:int = 0;

      private var admin_:Boolean = false;
      
      private var prefix_:SimpleText = null;
      
      public function RankText(numStars:int, largeText:Boolean, includePrefix:Boolean, rank:int = 0, isAdmin:Boolean = false)
      {
         super();
         this.largeText_ = largeText;
         if(includePrefix)
         {
            this.prefix_ = new SimpleText(!!this.largeText_?int(18):int(16),11776947,false,0,0);
            this.prefix_.setBold(this.largeText_);
            this.prefix_.text = "Rank: ";
            this.prefix_.updateMetrics();
            this.prefix_.filters = [new DropShadowFilter(0,0,0)];
            addChild(this.prefix_);
         }
         mouseEnabled = false;
         mouseChildren = false;
         this.draw(numStars, rank, isAdmin);
      }
      
      public function draw(numStars:int, rank:int, admin:Boolean) : void
      {
         var icon:Sprite = null;
         if (numStars == this.numStars_ && rank == this.rank_)
         {
            return;
         }
         this.numStars_ = numStars;
         this.rank_ = rank;
         this.admin_ = admin;
         if(this.sprite_ != null && contains(this.sprite_))
         {
            removeChild(this.sprite_);
         }
         if(this.numStars_ < 0)
         {
            return;
         }
         this.sprite_ = new Sprite();
         var text:SimpleText = new SimpleText(!!this.largeText_?int(18):int(16),11776947,false,0,0);
         text.setBold(this.largeText_);
         text.text = this.numStars_.toString() + (rank ? "-" + rank : "");
         text.updateMetrics();
         text.filters = [new DropShadowFilter(0,0,0,1,4,4,2)];
         this.sprite_.addChild(text);
         icon = !!this.largeText_?FameUtil.numStarsToBigImage(this.numStars_,this.admin_):FameUtil.numStarsToImage(this.numStars_,this.admin_);
         icon.x = text.width + 2;
         this.sprite_.addChild(icon);
         icon.y = int(text.height / 2 - icon.height / 2) + 1;
         var w:int = icon.x + icon.width;
         this.sprite_.graphics.clear();
         this.sprite_.graphics.beginFill(0,0.4);
         this.sprite_.graphics.drawRoundRect(-2,icon.y - 3,w + 6,icon.height + 8,12,12);
         this.sprite_.graphics.endFill();
         addChild(this.sprite_);
         if(this.prefix_ != null)
         {
            addChild(this.prefix_);
            this.sprite_.x = this.prefix_.width;
         }
      }
   }
}
