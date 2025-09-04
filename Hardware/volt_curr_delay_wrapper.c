
/*
 * Include Files
 *
 */
#if defined(MATLAB_MEX_FILE)
#include "tmwtypes.h"
#include "simstruc_types.h"
#else
#define SIMPLIFIED_RTWTYPES_COMPATIBILITY
#include "rtwtypes.h"
#undef SIMPLIFIED_RTWTYPES_COMPATIBILITY
#endif



/* %%%-SFUNWIZ_wrapper_includes_Changes_BEGIN --- EDIT HERE TO _END */
#include <math.h>
#include <stdbool.h>
/* %%%-SFUNWIZ_wrapper_includes_Changes_END --- EDIT HERE TO _BEGIN */
#define u_width 1
#define u_1_width 1
#define y_width 1
#define y_1_width 1

/*
 * Create external references here.  
 *
 */
/* %%%-SFUNWIZ_wrapper_externs_Changes_BEGIN --- EDIT HERE TO _END */
#define BUFFER_SIZE 512
static double voltage_buffer[BUFFER_SIZE];
static double current_buffer[BUFFER_SIZE];
static int write_index = 0;
static const int delay_samples = 83;
// Number of steps = Delay_time / Step_size
//                 = 0.004167 / 0.00005
//                  83.33  round to 83 steps
static bool initialized = false;  // <-- flag
/* %%%-SFUNWIZ_wrapper_externs_Changes_END --- EDIT HERE TO _BEGIN */

/*
 * Start function
 *
 */
extern void volt_curr_delay_Start_wrapper(void);

void volt_curr_delay_Start_wrapper(void)
{
/* %%%-SFUNWIZ_wrapper_Start_Changes_BEGIN --- EDIT HERE TO _END */
int i;
for (i = 0; i < BUFFER_SIZE; i++) {
    voltage_buffer[i] = 0.0;
    current_buffer[i] = 0.0;
}
write_index = 0;
initialized = false;  // <-- correctly reset flag
/* %%%-SFUNWIZ_wrapper_Start_Changes_END --- EDIT HERE TO _BEGIN */
}
/*
 * Output function
 *
 */
extern void volt_curr_delay_Outputs_wrapper(const real_T *Vorigin,
			const real_T *Iorigin,
			real_T *Vdelay,
			real_T *Idelay);

void volt_curr_delay_Outputs_wrapper(const real_T *Vorigin,
			const real_T *Iorigin,
			real_T *Vdelay,
			real_T *Idelay)
{
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_BEGIN --- EDIT HERE TO _END */
// Write inputs to respective buffers
voltage_buffer[write_index] = Vorigin[0];
current_buffer[write_index] = Iorigin[0];

// Compute read index
int read_index = write_index - delay_samples;
if (read_index < 0) {
    read_index += BUFFER_SIZE;
}

// Output logic
if (!initialized && write_index < delay_samples) {
    Vdelay[0] = 0.0;
    Idelay[0] = 0.0;
} else {
    Vdelay[0] = voltage_buffer[read_index];
    Idelay[0] = current_buffer[read_index];
    initialized = true;
}

// Update write index
write_index = (write_index + 1) % BUFFER_SIZE;
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_END --- EDIT HERE TO _BEGIN */
}


