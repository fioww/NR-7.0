package com.company.assembleegameclient.sound {
import com.company.assembleegameclient.parameters.Parameters;

import flash.media.SoundTransform;

public class SFX {

    private static var sfxTrans_:SoundTransform;


    public static function load():void {
        sfxTrans_ = new SoundTransform(((Parameters.data_.playSFX) ? 1 : 0));
    }

    public static function setPlaySFX(playSFX:Boolean):void {
        Parameters.data_.playSFX = playSFX;
        Parameters.save();
        SoundEffectLibrary.updateTransform();
    }

    public static function setSFXVolume(SFXVolume:Number):void {
        Parameters.data_.SFXVolume = SFXVolume;
        Parameters.save();
        SoundEffectLibrary.updateVolume(SFXVolume);
    }


}
}
