
let rec primes n = 
  let rec work m k acc = 
    if ((m mod k) = 0) && (k > 1) then let k = m in work (m+1) k acc 
    else if k = 1 then let k = m in work (m+1) k (m::acc)
    else if (List.length acc) = n then List.rev acc
    else work m (k-1) acc
  in
  work 2 1 []
    
let pretty prime_list =
  String.concat "," (List.map string_of_int prime_list)
      
  
let main = 
  let len = Array.length Sys.argv in (
    match len with
    | 2 -> (
        try
          let m = int_of_string Sys.argv.(1) in (
            if m >= 1 && m <= 100 then print_endline (pretty(primes m))
            else exit 1
          )
        with
        | Failure(_) -> exit 2
      )
    | _ -> exit 2
  )
  

    
    

