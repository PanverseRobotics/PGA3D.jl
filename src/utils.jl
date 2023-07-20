function increment_bracket_numbers(str::String)
  regex_bracket = r"\[(\d+)\]"
  regex_varname_a = r"a(\d+)"
  regex_varname_b = r"b(\d+)"
  new_str = replace(str, regex_bracket => s -> "[$(parse(Int, s[2:end-1]) + 1)]") # bracket numbers
  new_str = replace(new_str, regex_varname_a => s -> "a$(parse(Int, s[2:end]) + 1)") # variable name a
  new_str = replace(new_str, regex_varname_b => s -> "b$(parse(Int, s[2:end]) + 1)") # variable name b
  return new_str
end

#=
PGA symbolic calculator
https://enki.ws/ganja.js/examples/coffeeshop.html#665aoyv6x
  basis : "1,e0,e1,e2,e3,e01,e02,e03,e23,e31,e12,e021,e013,e032,e123,e0123".split(','),
  types : [
    { name : "scalar", layout : ["1"] },
    { name : "vector", layout : ["e0", "e1", "e2", "e3"] },
    { name : "bivector", layout : ["e23", "e31", "e12","e01", "e02", "e03"] },
    { name : "trivector", layout : ["e021", "e013", "e032", "e123"] },
    { name : "quadvector", layout : ["e0123"] },
    { name : "rotor", layout : ["e23", "e31", "e12", "1", "e01", "e02", "e03", "e0123"] },
    { name : "multivector", layout : "1,e01,e02,e03,e23,e31,e12,e021,e013,e032,e123,e0123,e0,e1,e2,e3".split(',') }
=#
