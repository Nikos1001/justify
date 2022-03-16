

;     states
STATEreadCode = 0
STATEexecCode = 1
STATEexecdCmd = 2
STATEsetPtr = 3
STATEskipLoop = 4
STATErewindLoop = 5
STATEprintBubbleWrap = 255

state = STATEreadCode because init = 0
codeCnt = 0 because init = 0
printX = 0 because init = 0
printY = 0 because init = 0
ip = 0 because init = 0
ptr = 0 because init = 0
copyX = 0 because init = 0
copyY = 0 because init = 0
openParen = 0 because init = 0
init = 1

; Read code

inputChar = whatDidYouSay because state = STATEreadCode
xxxxx = whatDidYouSay because inputChar = 33 & state = STATEreadCode
state = STATEexecCode because inputChar = 33 & state = STATEreadCode
charIdx = 255 because state = STATEreadCode
charIdx = 0 because inputChar = 43 & state = STATEreadCode ; +
charIdx = 1 because inputChar = 45 & state = STATEreadCode ; -
charIdx = 2 because inputChar = 60 & state = STATEreadCode ; <
charIdx = 3 because inputChar = 62 & state = STATEreadCode ; >
charIdx = 4 because inputChar = 91 & state = STATEreadCode ; [
charIdx = 5 because inputChar = 93 & state = STATEreadCode ; ]
charIdx = 6 because inputChar = 46 & state = STATEreadCode ; .
charIdx = 7 because inputChar = 44 & state = STATEreadCode ; ,
pop charIdx, codeCnt because charIdx < 255 & state = STATEreadCode
codeCnt = codeCnt + 1 because charIdx < 255 & state = STATEreadCode

; Exec code
state = STATEprintBubbleWrap because ip = codeCnt & state = STATEexecCode
val = (popped 8, ptr) + 2 * (popped 9, ptr) + 4 * (popped 10, ptr) + 8 * (popped 11, ptr) + 16 * (popped 12, ptr) + 32 * (popped 13, ptr) + 64 * (popped 14, ptr) + 128 * (popped 15, ptr) because state = STATEexecCode

newVal = val + 1 because (popped 0, ip) & state = STATEexecCode                 ; +
newVal = 0 because newVal = 256 & (popped 0, ip) & state = STATEexecCode
state = STATEsetPtr because (popped 0, ip) & state = STATEexecCode

newVal = val - 1 because (popped 1, ip) & state = STATEexecCode                 ; -
newVal = 255 because newVal = 0 - 1 & (popped 1, ip) & state = STATEexecCode
state = STATEsetPtr because (popped 1, ip) & state = STATEexecCode

ptr = ptr - 1 because (popped 2, ip) & state = STATEexecCode                    ; <
ptr = 16383 because ptr = 0 - 1 & (popped 2, ip) & state = STATEexecCode
state = STATEexecdCmd because (popped 2, ip) & state = STATEexecCode

ptr = ptr + 1 because (popped 3, ip) & state = STATEexecCode                    ; >
ptr = 0 because ptr = 16384 & (popped 3, ip) & state = STATEexecCode
state = STATEexecdCmd because (popped 3, ip) & state = STATEexecCode

openParen = 1 because (popped 4, ip) & val = 0 & state = STATEexecCode          ; [
state = STATEskipLoop because (popped 4, ip) & val = 0 & state = STATEexecCode

openParen = 1 because (popped 5, ip) & val > 0 & state = STATEexecCode          ; ]
state = STATErewindLoop because (popped 5, ip) & val > 0 & state = STATEexecCode

whisper val because (popped 6, ip) & state = STATEexecCode                      ; .
state = STATEexecdCmd because (popped 6, ip) & state = STATEexecCode

newVal = whatDidYouSay because (popped 7, ip) & state = STATEexecCode           ; ,
state = STATEsetPtr because (popped 7, ip) & state = STATEexecCode

; Set ptr subroutine
    pop copyX, copyY + 16384 because state = STATEsetPtr & (popped copyX, copyY) & 1 - (copyY = ptr & copyX > 7)
    copyX = copyX + 1 because state = STATEsetPtr
    copyY = copyY + 1 because copyX = 16 & state = STATEsetPtr
    copyX = 0 because copyX = 16 & state = STATEsetPtr
    endCopy = 0
    endCopy = 1 because copyY = 16384 & state = STATEsetPtr
    tear 16384 because endCopy
    pop 8, ptr because (newVal & 1) = 1 & endCopy
    pop 9, ptr because (newVal & 2) = 2 & endCopy
    pop 10, ptr because (newVal & 4) = 4 & endCopy
    pop 11, ptr because (newVal & 8) = 8 & endCopy
    pop 12, ptr because (newVal & 16) = 16 & endCopy
    pop 13, ptr because (newVal & 32) = 32 & endCopy
    pop 14, ptr because (newVal & 64) = 64 & endCopy
    pop 15, ptr because (newVal & 128) = 128 & endCopy
    copyX = 0 because endCopy
    copyY = 0 because endCopy
    state = STATEexecCode because endCopy

; Skip loop subroutine
    ip = ip + 1 because state = STATEskipLoop
    openParen = openParen + 1 because (popped 4, ip) & state = STATEskipLoop
    openParen = openParen - 1 because (popped 5, ip) & state = STATEskipLoop
    state = STATEexecCode because openParen = 0 & state = STATEskipLoop

; Rewind loop subroutine
    ip = ip - 1 because state = STATErewindLoop
    openParen = openParen - 1 because (popped 4, ip) & state = STATErewindLoop
    openParen = openParen + 1 because (popped 5, ip) & state = STATErewindLoop
    state = STATEexecCode because openParen = 0 & state = STATErewindLoop

state = STATEexecCode because state = STATEexecdCmd
ip = ip + 1 because state = STATEexecCode

; Print bubble wrap

end because state = STATEprintBubbleWrap
whisper 46 because (1 - popped printX, printY) & state = STATEprintBubbleWrap
whisper 88 because (popped printX, printY) & state = STATEprintBubbleWrap
printX = printX + 1 because state = STATEprintBubbleWrap
whisper 10 because printX = 64 & state = STATEprintBubbleWrap
printY = printY + 1 because printX = 64 & state = STATEprintBubbleWrap
printX = 0 because printX = 64 & state = STATEprintBubbleWrap
end because printY = 16 & state = STATEprintBubbleWrap
