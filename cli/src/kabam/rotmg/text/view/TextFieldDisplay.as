package kabam.rotmg.text.view {
import flash.text.TextField;

import kabam.rotmg.language.model.StringMap;
import kabam.rotmg.text.model.FontInfo;

public interface TextFieldDisplay {

    function setTextField(textField:TextField):void;

    function setStringMap(stringMap:StringMap):void;

    function setFont(fontInfo:FontInfo):void;

}
}
