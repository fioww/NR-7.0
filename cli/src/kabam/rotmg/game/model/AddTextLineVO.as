package kabam.rotmg.game.model
{
   public class AddTextLineVO
   {
       
      
      public var name:String;
      
      public var objectId:int;
      
      public var numStars:int;

      public var isAdmin:Boolean;
      
      public var recipient:String;
      
      public var text:String;
      
      public function AddTextLineVO(name:String, text:String, objectId:int = -1, numStars:int = -1, isAdmin:Boolean = false, recipient:String = "")
      {
         super();
         this.name = name;
         this.objectId = objectId;
         this.numStars = numStars;
         this.isAdmin = isAdmin;
         this.recipient = recipient;
         this.text = text;
      }
   }
}
