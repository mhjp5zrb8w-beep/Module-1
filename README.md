After slightly change the code, we achieve some results.
  0.071861 seconds (1.02 M allocations: 107.401 MiB, 42.86% gc time, 11.48% compilation time)
   0.035552 seconds (6.88 k allocations: 46.160 MiB, 19.77% gc time, 29.69% compilation time)

I optimized the code by removing unnecessary memory allocations and reducing type instability. I passed data into functions instead of using a non-constant global variable, preallocated arrays with zeros, replaced the temporary array in the Monte Carlo loop with scalar variables, avoided copying matrix rows, and initialized the accumulator as a floating-point number. The optimized version ran faster and allocated less memory than the original version.

I created a public GitHub repository for the exercise and used commits to track the changes from the original version to the optimized version.

AI is too good at doing all that staff
