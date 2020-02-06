/**
 * Created by cp-nilly on 6/9/2017.
 */
package kabam.rotmg.messaging.impl.incoming {
import flash.utils.IDataInput;

public class SwitchMusic extends IncomingMessage {
    public var music:String;

    public function SwitchMusic(num:uint, func:Function) {
        super(num, func);
    }

    override public function parseFromInput(input:IDataInput):void {
        this.music = input.readUTF();
    }

    override public function toString():String {
        return (formatToString("SWITCHMUSIC", "music_"));
    }


}
}