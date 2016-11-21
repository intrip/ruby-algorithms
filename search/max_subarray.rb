# brute force algorith to solve the max subarray problem
def max_subarray_brute(arr, len = nil)
   len ||= arr.length() -1

   from=0
   to= 0
   max = 0

   for i in 0..len
      for j in (i+1)..len
         tsum = arr[i..j].reduce(:+)
         if tsum > max
            max = tsum
            from = i
            to = j
         end
      end
   end

   {sum: max,from: from,to: to}
end

# knowing that the max continuos subarray at the index j+1 is either the max subarray
# of [0..j] or an array in [i..j+1] where 0<=i<=j+1
def max_subarray_opt(arr, len=nil)
   len ||= arr.length() -1

   max = 0
   from=0
   to=0

   tmax=0
   tfrom=-1

   for i in 0..len
      tmax = tmax + arr[i]

      if tmax < 0
         tmax=0
         tfrom = -1
      else
         if tfrom == -1
            tfrom = i
         end
         # found the new max
         if tmax > max
            max=tmax
            to=i
            from=tfrom
         end
      end

   end

   {sum: max,from: from,to: to}
end

arr = [13,-3,-25,20,-3,-16,-23,18,20,-7,12,-5,-22,15,-4,7]
# the results should be arr[18] (7) , arr[12] (10)

require 'benchmark'
Benchmark.bm do |x|
	x.report("max_subarray_brute: ") { for i in 1..10000; max_subarray_brute(arr) end;}
	x.report("max_subarray_opt: ") { for i in 1..10000; max_subarray_opt(arr) end;}
end

p max_subarray_brute(arr)
p max_subarray_opt(arr)
