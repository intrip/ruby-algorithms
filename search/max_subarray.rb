=begin
   brute force algorith to solve the max subarray problem
=end

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


arr = [13,-3,-25,20,-3,-16,-23,18,20,-7,12,-5,-22,15,-4,7]
# the results should be arr[18],arr[12]
p max_subarray_brute(arr)
