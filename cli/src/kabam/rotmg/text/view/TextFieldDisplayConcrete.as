package kabam.rotmg.text.view {
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextLineMetrics;

import kabam.rotmg.language.model.StringMap;
import kabam.rotmg.text.model.FontInfo;
import kabam.rotmg.text.view.stringBuilder.StringBuilder;

import org.osflash.signals.Signal;

public class TextFieldDisplayConcrete extends Sprite implements TextFieldDisplay {

    public static const MIDDLE:String = "middle";
    public static const BOTTOM:String = "bottom";
    private static const GUTTER:int = 2;

    public const textChanged:Signal = new Signal();

    public var textField:TextField;
    private var stringMap:StringMap;
    private var stringBuilder:StringBuilder;
    private var size:int = 12;
    private var color:uint;
    private var font:FontInfo;
    private var bold:Boolean;
    private var autoSize:String = "left";
    private var horizontalAlign:String = "left";
    private var verticalAlign:String;
    private var multiline:Boolean;
    private var wordWrap:Boolean;
    private var textWidth:Number = 0;
    private var textHeight:Number = 0;
    private var html:Boolean;
    private var displayAsPassword:Boolean;
    private var debugName:String;
    private var leftMargin:int = 0;
    private var indent:int = 0;
    private var leading:int = 0;


    private static function getOnlyTextHeight(textLineMetrics:TextLineMetrics):Number {
        return ((textLineMetrics.height - textLineMetrics.leading));
    }


    public function setIndent(val:int):TextFieldDisplayConcrete {
        this.indent = val;
        this.setPropertiesIfHasTextField();
        return (this);
    }

    public function setLeading(val:int):TextFieldDisplayConcrete {
        this.leading = val;
        this.setPropertiesIfHasTextField();
        return (this);
    }

    public function setLeftMargin(val:int):TextFieldDisplayConcrete {
        this.leftMargin = val;
        this.setPropertiesIfHasTextField();
        return (this);
    }

    public function setDisplayAsPassword(display:Boolean):TextFieldDisplayConcrete {
        this.displayAsPassword = display;
        this.setPropertiesIfHasTextField();
        return (this);
    }

    public function setDebugName(val:String):TextFieldDisplayConcrete {
        this.debugName = val;
        ((this.textField) && ((this.textField.name = this.debugName)));
        return (this);
    }

    public function setSize(val:int):TextFieldDisplayConcrete {
        this.size = val;
        this.setPropertiesIfHasTextField();
        return (this);
    }

    public function setColor(color:uint):TextFieldDisplayConcrete {
        this.color = color;
        this.setPropertiesIfHasTextField();
        return (this);
    }

    public function setBold(bold:Boolean):TextFieldDisplayConcrete {
        this.bold = bold;
        this.setPropertiesIfHasTextField();
        return (this);
    }

    public function setHorizontalAlign(text:String):TextFieldDisplayConcrete {
        this.horizontalAlign = text;
        this.setPropertiesIfHasTextField();
        return (this);
    }

    public function setAutoSize(size:String):TextFieldDisplayConcrete {
        this.autoSize = size;
        this.setPropertiesIfHasTextField();
        return (this);
    }

    public function setMultiLine(multiLine:Boolean):TextFieldDisplayConcrete {
        this.multiline = multiLine;
        this.setPropertiesIfHasTextField();
        return (this);
    }

    public function setWordWrap(wordWrap:Boolean):TextFieldDisplayConcrete {
        this.wordWrap = wordWrap;
        this.setPropertiesIfHasTextField();
        return (this);
    }

    public function setTextWidth(width:Number):TextFieldDisplayConcrete {
        this.textWidth = width;
        this.setPropertiesIfHasTextField();
        return (this);
    }

    public function setTextHeight(height:Number):TextFieldDisplayConcrete {
        this.textHeight = height;
        this.setPropertiesIfHasTextField();
        return (this);
    }

    public function setHTML(HTML:Boolean):TextFieldDisplayConcrete {
        this.html = HTML;
        return (this);
    }

    public function setStringBuilder(stringBuilder:StringBuilder):TextFieldDisplayConcrete {
        this.stringBuilder = stringBuilder;
        this.setTextIfAble();
        return (this);
    }

    public function getStringBuilder():StringBuilder {
        return (this.stringBuilder);
    }

    public function setPosition(xPos:Number, yPos:Number):TextFieldDisplayConcrete {
        this.x = xPos;
        this.y = yPos;
        return (this);
    }

    public function setVerticalAlign(verticalAllign:String):TextFieldDisplayConcrete {
        this.verticalAlign = verticalAllign;
        return (this);
    }

    public function update():void {
        this.setTextIfAble();
    }

    public function setFont(font:FontInfo):void {
        this.font = font;
    }

    public function setStringMap(stringMap:StringMap):void {
        this.stringMap = stringMap;
        this.setTextIfAble();
    }

    public function setTextField(textField:TextField):void {
        textField.width = this.textWidth;
        textField.height = this.textHeight;
        ((this.debugName) && ((textField.name = this.debugName)));
        this.updateTextOfInjectedTextField(textField);
        this.textField = textField;
        this.setProperties();
        addChild(this.textField);
    }

    private function setPropertiesIfHasTextField():void {
        if (this.textField) {
            this.setProperties();
        }
    }

    private function setProperties():void {
        this.setFormatProperties();
        this.setTextFieldProperties();
    }

    private function setTextFieldProperties():void {
        if (this.textWidth != 0) {
            this.textField.width = this.textWidth;
        }
        if (this.textHeight != 0) {
            this.textField.height = this.textHeight;
        }
        this.textField.selectable = false;
        this.textField.textColor = this.color;
        this.textField.autoSize = this.autoSize;
        this.textField.multiline = this.multiline;
        this.textField.wordWrap = this.wordWrap;
        this.textField.displayAsPassword = this.displayAsPassword;
        this.textField.embedFonts = true;
    }

    private function setFormatProperties():void {
        var textFormat:TextFormat = new TextFormat();
        textFormat.size = this.size;
        textFormat.font = this.font.getName();
        textFormat.bold = this.bold;
        textFormat.align = this.horizontalAlign;
        textFormat.leftMargin = this.leftMargin;
        textFormat.indent = this.indent;
        textFormat.leading = this.leading;
        this.setTextFormat(textFormat);
    }

    private function updateTextOfInjectedTextField(textField:TextField):void {
        if (this.textField) {
            textField.text = this.textField.text;
            removeChild(this.textField);
        }
    }

    private function setTextIfAble():void {
        var text:String;
        if (this.isAble()) {
            this.stringBuilder.setStringMap(this.stringMap);
            text = this.stringBuilder.getString();
            this.setText(text);
            this.alignVertically();
            this.invalidateTextField();
            this.textChanged.dispatch();
        }
    }

    private function invalidateTextField():void {
        this.textField.height;
    }

    public function setText(text:String):void {
        if (this.html) {
            this.textField.htmlText = text;
        }
        else {
            this.textField.text = text;
        }
    }

    private function alignVertically():void {
        var textLineMetrics:TextLineMetrics;
        if (this.verticalAlign == MIDDLE) {
            this.setYToMiddle();
        }
        else {
            if (this.verticalAlign == BOTTOM) {
                textLineMetrics = this.textField.getLineMetrics(0);
                this.textField.y = -(getOnlyTextHeight(textLineMetrics));
            }
        }
    }

    public function getTextHeight():Number {
        return (((this.textField) ? this.textField.height : 0));
    }

    private function setYToMiddle():void {
        this.textField.height;
        var textFormat:TextFormat = this.textField.getTextFormat();
        var height:Number = this.getSpecificXHeight(textFormat);
        var verticalSpace:Number = this.getSpecificVerticalSpace(textFormat);
        this.textField.y = -((this.textField.height - (((height / 2) + verticalSpace) + GUTTER)));
    }

    private function getSpecificXHeight(textFormat:TextFormat):Number {
        return (this.font.getXHeight(Number(textFormat.size)));
    }

    private function getSpecificVerticalSpace(textFormat:TextFormat):Number {
        return (this.font.getVerticalSpace(Number(textFormat.size)));
    }

    public function setTextFormat(textFormat:TextFormat, val1:int = -1, val2:int = -1):void {
        this.textField.defaultTextFormat = textFormat;
        this.textField.setTextFormat(textFormat, val1, val2);
    }

    private function isAble():Boolean {
        return (((((this.stringMap) && (this.stringBuilder))) && (this.textField)));
    }

    public function getVerticalSpace():Number {
        return (this.font.getVerticalSpace(Number(this.textField.getTextFormat().size)));
    }

    public function getText():String {
        return (((this.textField) ? this.textField.text : "null"));
    }

    public function getColor():uint {
        return (this.color);
    }

    public function getSize():int {
        return (this.size);
    }

    public function hasTextField():Boolean {
        return (!((this.textField == null)));
    }

    public function hasStringMap():Boolean {
        return (!((this.stringMap == null)));
    }

    public function hasFont():Boolean {
        return (!((this.font == null)));
    }

    public function getTextFormat(val1:int = -1, val2:int = -1):TextFormat {
        return (this.textField.getTextFormat(val1, val2));
    }


}
}
