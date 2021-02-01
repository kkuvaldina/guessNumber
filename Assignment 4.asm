#Assignment 4 - Number to Guess
#Author: Kseniia Kuvaldina
#CSIS-2810

.data
    numToGuess:                 .word       37
    numberOfGuesses:            .word       5
    returnValue:                .word       0
    loseMessage:                .asciiz     "\n\nYou had your five guesses!\n"
    promptToEnterTheNumber:     .asciiz     "\n\nGuess the number between 1 and 100: "
    goodGuessMessage:           .asciiz     "\nGood guess!"
    congratulationsMessage:     .asciiz     "\nCongratulations!\n"
    tooLowMessage:              .asciiz     "\nToo low!"
    tooHiMessage:               .asciiz     "\nToo hi!"

.text
main:
    lw	$t0, numToGuess         # 37  
    lw	$t1, numberOfGuesses    # 5 guesses
    li  $t2, 0                  # i counter for loop
    lw  $t4, returnValue        

loop:
    #if t1 == 5 game is over, no more than 5 guesses allowed
    beq $t1, $t2, lose

    #asking the user to provide the number
    li  $v0, 4          
    la  $a0, promptToEnterTheNumber    
    syscall             
    
    #reading the number provided by the user
    li  $v0, 5          
    syscall             
    move    $t3, $v0

    #jump to compareNumbers
    jal compareNumbers

    #get return value from compareNumbers
    add $a0, $v0, $0

    #if return value doesn't equal 0 jump to the "congratulate"
    bne $a0, $0, congratulate

    #if return value equals 0 continue going through the loop
    j loop

compareNumbers:
    #comparing the number with the guess number
    blt $t3, $t0, else
    beq $t3, $t0, win

    #print "Too hi" message
    li  $v0, 4          
    la  $a0, tooHiMessage    
    syscall

    addi $t2, $t2, 1        #add 1 to $t2 counter i
    add $v0, $t4, $0        #save value 0 to return
    jr $ra

    else:
        #print "Too low" message
        li  $v0, 4          
        la  $a0, tooLowMessage    
        syscall

        addi $t2, $t2, 1    #add 1 to $t2 counter i
        add $v0, $t4, $0    #save value 0 to return
        jr $ra

    win:
        #print "Good guess" message
        li  $v0, 4          
        la  $a0, goodGuessMessage    
        syscall

        add $v0, $t4, 1     #save value 1 to return
        jr $ra
    
congratulate:
    #print "Congratulations" message
    li  $v0, 4          
    la  $a0, congratulationsMessage    
    syscall
    j end

lose:
    #print "You had your five guesses" message
    li  $v0, 4          
    la  $a0, loseMessage    
    syscall

end: