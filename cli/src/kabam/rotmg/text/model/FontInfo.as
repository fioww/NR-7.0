package kabam.rotmg.text.model {
import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

public class FontInfo {

    private static const renderingFontSize:Number = 200;
    private static const GUTTER:Number = 2;

    protected var name:String;
    private var textColor:uint = 0;
    private var xHeightRatio:Number;
    private var verticalSpaceRatio:Number;


    public function setName(name:String):void {
        this.name = name;
        this.computeRatiosByRendering();
    }

    public function getName():String {
        return (this.name);
    }

    public function getXHeight(height:Number):Number {
        return ((this.xHeightRatio * height));
    }

    public function getVerticalSpace(space:Number):Number {
        return ((this.verticalSpaceRatio * space));
    }

    private function computeRatiosByRendering():void {
        var text:TextField = this.makeTextField();
        var bitmap:BitmapData = new BitmapDataSpy(text.width, text.height);
        bitmap.draw(text);
        var color:uint = 0xFFFFFF;
        var rect:Rectangle = bitmap.getColorBoundsRect(color, this.textColor, true);
        this.xHeightRatio = this.deNormalize(rect.height);
        this.verticalSpaceRatio = this.deNormalize(((text.height - rect.bottom) - GUTTER));
    }

    private function makeTextField():TextField {
        var text:TextField = new TextField();
        text.autoSize = TextFieldAutoSize.LEFT;
        text.text = "x";
        text.textColor = this.textColor;
        text.setTextFormat(new TextFormat(this.name, renderingFontSize));
        return (text);
    }

    private function deNormalize(number:Number):Number {
        return ((number / renderingFontSize));
    }


}
}
