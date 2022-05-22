# bowling-points

App consists of 2 classes:
1. Game - overall game workflow (frame calculations)
2. Frame - frame workflow (ball caclucations)

In order to play the game, run in console:
```
ruby bowling.rb
```

In order to launch tests, run in console:
```
rspec
```

## Implementation idea

Basic idea is to store each frame as an object of a Frame class. By adding balls to each frame we could either know results of the frame (if all ball sum is less than 10) or not now it yet (if we have a strike or a spare).
If a frame is spare or strike, we need to keep it 'open' (is_open_score attribute). By flagging it that way we will know that this frame will need a calculation to be run upon.
When next balls are being played, we add them to previous 'open' frames if appropriate and close the result. Last frame of the game has a bit different finishing rules as player gets extra ball to throw if he has a stike or a spare.
