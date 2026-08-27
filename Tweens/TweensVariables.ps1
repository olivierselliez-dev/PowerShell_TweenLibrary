<#
.SYNOPSIS
    Easing function string constants for the Tweening library.
.DESCRIPTION
    This script defines the global script-scoped string identifiers for each supported 
    Robert Penner easing equation (Linear, Expo, Circ, Quad, Sine, Cubic, Quart, 
    Quint, Elastic, Bounce, Back) with their variations (In, Out, InOut, OutIn).
.NOTES
    Author: Olivier Selliez
    Email: olivier.selliez.dev@gmail.com
#>

#region variables d'easing
#region Linear
# Linear interpolation (constant speed)
[string]$Script:easeLinear = "Linear" #0
#endregion
#region Expo
# Exponential easing (based on 2^t curve)
[string]$Script:easeExpoOut = "ExpoEaseOut" #1
[string]$Script:easeExpoIn = "ExpoEaseIn" #2
[string]$Script:easeExpoInOut = "ExpoEaseInOut" #3
[string]$Script:easeExpoOutIn = "ExpoEaseOutIn" #4
#endregion 
#region Circ
# Circular easing (based on sqrt(1 - t^2) curve)
[string]$Script:easeCircOut = "CircEaseOut" #5
[string]$Script:easeCircIn = "CircEaseIn" #6
[string]$Script:easeCircInOut = "CircEaseInOut" #7
[string]$Script:easeCircOutIn = "CircEaseOutIn" #8
#endregion
#region Quad
# Quadratic easing (based on t^2 curve)
[string]$Script:easeQuadOut = "QuadEaseOut" #9
[string]$Script:easeQuadIn = "QuadEaseIn" #10
[string]$Script:easeQuadInOut = "QuadEaseInOut" #11
[string]$Script:easeQuadOutIn = "QuadEaseOutIn" #12
#endregion
#region Sine
# Sinusoidal easing (based on sin/cos trigonometric curves)
[string]$Script:easeSineOut = "SineEaseOut" #13
[string]$Script:easeSineIn = "SineEaseIn" #14
[string]$Script:easeSineInOut = "SineEaseInOut" #15
[string]$Script:easeSineOutIn = "SineEaseOutIn" #16
#endregion
#region Cubic
# Cubic easing (based on t^3 curve)
[string]$Script:easeCubicOut = "CubicEaseOut" #17
[string]$Script:easeCubicIn = "CubicEaseIn" #18
[string]$Script:easeCubicInOut = "CubicEaseInOut" #19
[string]$Script:easeCubicOutIn = "CubicEaseOutIn" #20
#endregion
#region Quart
# Quartic easing (based on t^4 curve)
[string]$Script:easeQuartOut = "QuartEaseOut" #21
[string]$Script:easeQuartIn = "QuartEaseIn" #22
[string]$Script:easeQuartInOut = "QuartEaseInOut" #23
[string]$Script:easeQuartOutIn = "QuartEaseOutIn" #24
#endregion
#region Quint
# Quintic easing (based on t^5 curve)
[string]$Script:easeQuintOut = "QuintEaseOut" #25
[string]$Script:easeQuintIn = "QuintEaseIn" #26
[string]$Script:easeQuintInOut = "QuintEaseInOut" #27
[string]$Script:easeQuintOutIn = "QuintEaseOutIn" #28
#endregion
#region Elastic
# Elastic easing (exponentially decaying sine wave / rubber band effect)
[string]$Script:easeElasticOut = "ElasticEaseOut" #29
[string]$Script:easeElasticIn = "ElasticEaseIn" #30
[string]$Script:easeElasticInOut = "ElasticEaseInOut" #31
[string]$Script:easeElasticOutIn = "ElasticEaseOutIn" #32
#endregion
#region Bounce
# Bouncing easing (exponentially decaying parabolic bounces)
[string]$Script:easeBounceOut = "BounceEaseOut" #33
[string]$Script:easeBounceIn = "BounceEaseIn" #34
[string]$Script:easeBounceInOut = "BounceEaseInOut" #35
[string]$Script:easeBounceOutIn = "BounceEaseOutIn" #36
#endregion
#region Back
# Back easing (overshooting cubic equation)
[string]$Script:easeBackOut = "BackEaseOut" #37
[string]$Script:easeBackIn = "BackEaseIn" #38
[string]$Script:easeBackInOut = "BackEaseInOut" #39
[string]$Script:easeBackOutIn = "BackEaseOutIn" #40
#endregion
#endregion