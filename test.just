
pop 0, 0 because init = 0
pop 1, 1 because init = 0
pop 2, 1 because init = 0
pop 2, 3 because init = 0
tear 2 because init = 0

x = 0 because init = 0
y = 0 because init = 0
init = 1

whisper 46 because 1 - popped x, y
whisper 88 because popped x, y
x = x + 1
whisper 10 because x = 64
y = y + 1 because x = 64
x = 0 because x = 64

end because y = 5

