.origin 0
.entrypoint START

#define PRU0_ARM_INTERRUPT 19
#define INS_PER_US   200
#define INS_PER_DELAY_LOOP 2
#define FREQUENCY 1000 // hertz maximum is 2.1 kHz
#define DELAY  1000 / (FREQUENCY * 2) * 1000 * (INS_PER_US / INS_PER_DELAY_LOOP)
#define DURATION 5 // seconds
#define TICKS DURATION * FREQUENCY * 2

START:
    LBCO r0, C4, 4, 4					// Load Bytes Constant Offset (?)
    CLR  r0, r0, 4						// Clear bit 4 in reg 0
    SBCO r0, C4, 4, 4					// Store Bytes Constant Offset

    MOV r1, TICKS 
HIGH:
    SET r30.t5   
    MOV r0, DELAY
DELAYON:
    SUB r0, r0, 1
    QBNE DELAYON, r0, 0
LOW:
    CLR r30.t5  
    MOV r0, DELAY
DELAYOFF:
    SUB r0, r0, 1
    QBNE DELAYOFF, r0, 0
    SUB r1, r1, 1
    QBNE HIGH, r1, 0

    MOV R31.b0, PRU0_ARM_INTERRUPT+16   // Send notification to Host for program completion
HALT