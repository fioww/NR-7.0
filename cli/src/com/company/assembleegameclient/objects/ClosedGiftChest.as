package com.company.assembleegameclient.objects
{
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.ui.panels.ButtonPanel;
import com.company.assembleegameclient.ui.panels.Panel;
import com.company.assembleegameclient.ui.tooltip.TextToolTip;
import com.company.assembleegameclient.ui.tooltip.ToolTip;

public class ClosedGiftChest extends GameObject implements IInteractiveObject
{


    public function ClosedGiftChest(objectXML:XML)
    {
        super(objectXML);
        isInteractive_ = true;
    }

    public function getTooltip() : ToolTip
    {
        var toolTip:ToolTip = new TextToolTip(3552822,10197915,"Gift Chest","Gift Chest is empty",200);
        return toolTip;
    }

    public function getPanel(gs:GameSprite) : Panel
    {
        return new ButtonPanel(gs, "Gift Chest is empty", "");
    }
}
}