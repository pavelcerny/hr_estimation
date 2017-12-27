function [ bb ] = esGetBB( Detection )

BB = Detection.Position.BoundingBox;
bb = [BB.TopLeftCol BB.TopLeftRow BB.BotRightCol BB.BotRightRow];
end

