package com.company.assembleegameclient.ui.options {
import com.company.assembleegameclient.parameters.Parameters;

import flash.events.Event;

public class SliderOption extends Option {

    private var sliderBar:VolumeSliderBar;
    private var disabled_:Boolean;
    private var callbackFunc:Function;

    public function SliderOption(text:String, func:Function = null, enabled:Boolean = false) {
        super(text, "", "");
        this.sliderBar = new VolumeSliderBar(Parameters.data_[paramName_]);
        this.sliderBar.addEventListener(Event.CHANGE, this.onChange);
        this.callbackFunc = func;
        addChild(this.sliderBar);
        this.setDisabled(enabled);
    }

    public function setDisabled(enabled:Boolean):void {
        this.disabled_ = enabled;
        mouseEnabled = !(this.disabled_);
        mouseChildren = !(this.disabled_);
    }

    override public function refresh():void {
        this.sliderBar.currentVolume = Parameters.data_[paramName_];
    }

    private function onChange(evt:Event):void {
        Parameters.data_[paramName_] = this.sliderBar.currentVolume;
        if (this.callbackFunc != null) {
            this.callbackFunc(this.sliderBar.currentVolume);
        }
        Parameters.save();
    }


}
}
