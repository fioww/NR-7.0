package com.company.assembleegameclient.sound {
import com.company.assembleegameclient.parameters.Parameters;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.net.URLRequest;
import flash.utils.Dictionary;

import kabam.rotmg.application.api.ApplicationSetup;
import kabam.rotmg.core.StaticInjectorContext;

public class SoundEffectLibrary {

    private static const URL_PATTERN:String = "{URLBASE}/sfx/{NAME}.mp3";

    private static var urlBase:String;
    public static var nameMap_:Dictionary = new Dictionary();
    private static var activeSfxList_:Dictionary = new Dictionary(true);


    public static function load(sfxName:String):Sound {
        return ((nameMap_[sfxName] = ((nameMap_[sfxName]) || (makeSound(sfxName)))));
    }

    public static function makeSound(sfxName:String):Sound {
        var sound:Sound = new Sound();
        sound.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
        sound.load(makeSoundRequest(sfxName));
        return (sound);
    }

    private static function getUrlBase():String {
        var setup:ApplicationSetup;
        var base:String = "";
        try {
            setup = StaticInjectorContext.getInjector().getInstance(ApplicationSetup);
            base = setup.getAppEngineUrl(true);
        }
        catch (error:Error) {
            base = "localhost";
        }
        return (base);
    }

    private static function makeSoundRequest(sfxName:String):URLRequest {
        urlBase = ((urlBase) || (getUrlBase()));
        var path:String = URL_PATTERN.replace("{URLBASE}", urlBase).replace("{NAME}", sfxName);
        return (new URLRequest(path));
    }

    public static function play(name:String, volumeMultiplier:Number = 1, isFX:Boolean = true):void {
        var actualVolume:Number;
        var trans:SoundTransform;
        var channel:SoundChannel;
        var sound:Sound = load(name);
        var volume:* = (Parameters.data_.SFXVolume * volumeMultiplier);
        try {
            actualVolume = ((((((Parameters.data_.playSFX) && (isFX))) || (((!(isFX)) && (Parameters.data_.playPewPew))))) ? volume : 0);
            trans = new SoundTransform(actualVolume);
            channel = sound.play(0, 0, trans);
            channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete, false, 0, true);
            activeSfxList_[channel] = volume;
        }
        catch (error:Error) {
        }
    }

    private static function onSoundComplete(evt:Event):void {
        var channel:SoundChannel = (evt.target as SoundChannel);
        delete activeSfxList_[channel];
    }

    public static function updateVolume(vol:Number):void {
        var channel:SoundChannel;
        var transform:SoundTransform;
        for each (channel in activeSfxList_) {
            activeSfxList_[channel] = vol;
            transform = channel.soundTransform;
            transform.volume = ((Parameters.data_.playSFX) ? activeSfxList_[channel] : 0);
            channel.soundTransform = transform;
        }
    }

    public static function updateTransform():void {
        var channel:SoundChannel;
        var transform:SoundTransform;
        for each (channel in activeSfxList_) {
            transform = channel.soundTransform;
            transform.volume = ((Parameters.data_.playSFX) ? activeSfxList_[channel] : 0);
            channel.soundTransform = transform;
        }
    }

    public static function onIOError(ioErrorEvent:IOErrorEvent):void {
    }


}
}
