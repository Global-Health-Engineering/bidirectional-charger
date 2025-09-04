
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
/* %%%-SFUNWIZ_wrapper_includes_Changes_END --- EDIT HERE TO _BEGIN */
#define u_width 1
#define y_width 1

/*
 * Create external references here.  
 *
 */
/* %%%-SFUNWIZ_wrapper_externs_Changes_BEGIN --- EDIT HERE TO _END */
// State variables 02
static double v_alpha = 0.0;
static double v_beta = 0.0;
static double w_est = 2.0*M_PI*60.0;
static double pi_integral = 0.0;
static double theta = 0.0;

// Parameters
//static double Kp = 100;
//static double Ki = 10000;

//static double Ts = 5e-5;               // Sampling time (50 µs)
//static double wn = 2.0 * M_PI * 60.0;  // Nominal freqquency (rad/s)

// Low-pass filter for phase error smoothing
static double phase_error_filtered = 0.0;
static double alpha_filter = 0.1; // Filter coefficient for low-pass filtering phase error
/* %%%-SFUNWIZ_wrapper_externs_Changes_END --- EDIT HERE TO _BEGIN */

/*
 * Start function
 *
 */
extern void pll_function_Start_wrapper(const real_T *Kp_pll, const int_T p_width0,
			const real_T *Ki_pll, const int_T p_width1,
			const real_T *w_nom, const int_T p_width2);

void pll_function_Start_wrapper(const real_T *Kp_pll, const int_T p_width0,
			const real_T *Ki_pll, const int_T p_width1,
			const real_T *w_nom, const int_T p_width2)
{
/* %%%-SFUNWIZ_wrapper_Start_Changes_BEGIN --- EDIT HERE TO _END */
pi_integral = 0.0;
    theta = 0.0;
/* %%%-SFUNWIZ_wrapper_Start_Changes_END --- EDIT HERE TO _BEGIN */
}
/*
 * Output function
 *
 */
extern void pll_function_Outputs_wrapper(const real_T *Vac,
			real_T *phase,
			const real_T *Kp_pll, const int_T p_width0,
			const real_T *Ki_pll, const int_T p_width1,
			const real_T *w_nom, const int_T p_width2);

void pll_function_Outputs_wrapper(const real_T *Vac,
			real_T *phase,
			const real_T *Kp_pll, const int_T p_width0,
			const real_T *Ki_pll, const int_T p_width1,
			const real_T *w_nom, const int_T p_width2)
{
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_BEGIN --- EDIT HERE TO _END */
// Get input voltage (single-phase)

    // parameters
    double Kp = Kp_pll[0];
    double Ki = Ki_pll[0];
    double wn = w_nom[0];
    const double Ts = 5e-5;  // Fixed sample time

   // Get input voltage (single-phase)
    double v = Vac[0];

    //  orthogonal signal generator (SOGI-like behavior)
    double v_alpha_next = v_alpha + Ts * (wn * (v - v_alpha) + wn * v_beta);
    double v_beta_next  = v_beta + Ts * (-wn * v_alpha);

    // Phase detector using arctangent
    double phase_detector = atan2(-v_beta, v_alpha);

    // Fix: Adjust 90° offset so PLL aligns with zero-crossing of Vac
    phase_detector += M_PI_2;

    // Normalize detector angle to [-pi, pi]
    if (phase_detector > M_PI) phase_detector -= 2 * M_PI;
    if (phase_detector < -M_PI) phase_detector += 2 * M_PI;

    // Phase error = phase_detector - theta
    double phase_error = phase_detector - theta;  

    // Normalize phase error
    if (phase_error > M_PI) phase_error -= 2 * M_PI;
    if (phase_error < -M_PI) phase_error += 2 * M_PI;

    // Low-pass filter phase error to reduce noise
    phase_error_filtered = (1.0 - alpha_filter) * phase_error_filtered + alpha_filter * phase_error;

    // PI control (use filtered phase error here)
    pi_integral += Ki * Ts * phase_error_filtered;
    double delta_w = Kp * phase_error_filtered + pi_integral;

    // Estimated angular frequency
    w_est = wn + delta_w;

    // Integrate to get phase
    theta += Ts * w_est;

    // Wrap angle to [0, 2)
    if (theta >= 2.0 * M_PI) theta -= 2.0 * M_PI;
    if (theta < 0.0) theta += 2.0 * M_PI;

    // Output phase angle
    phase[0] = theta;

    // Update states
    v_alpha = v_alpha_next;
    v_beta = v_beta_next;
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_END --- EDIT HERE TO _BEGIN */
}


