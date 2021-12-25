package kabam.rotmg.messaging.impl.outgoing
{
import flash.utils.IDataOutput;

import kabam.rotmg.messaging.impl.data.MoveRecord;
import kabam.rotmg.messaging.impl.data.WorldPosData;

public class Move extends OutgoingMessage
{

   public var objectId_:int;
   public var tickId_:int;
   public var time_:int;
   public var newPosition_:WorldPosData;
   public var records_:Vector.<MoveRecord>;

   public function Move(id:uint, callback:Function)
   {
      this.newPosition_ = new WorldPosData();
      this.records_ = new Vector.<MoveRecord>();
      super(id, callback);
   }

   override public function writeToOutput(data:IDataOutput):void
   {
      data.writeInt(this.objectId_);
      data.writeInt(this.tickId_);
      data.writeInt(this.time_);
      this.newPosition_.writeToOutput(data);
      data.writeShort(this.records_.length);
      var len:int = 0;
      while (len < this.records_.length)
      {
         this.records_[len].writeToOutput(data);
         len++;
      }
   }

   override public function toString():String
   {
      return (formatToString("MOVE", "objectId_", "tickId_", "time_", "newPosition_", "records_"));
   }

}
}