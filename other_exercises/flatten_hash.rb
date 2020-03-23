hash = {
  john: {
    doe: 1,
    dere: [1,2,3]
  },
  mel: {
    gibson: 1,
    sub: {
      don: "lol"
    },
    arr: [1,2]
  },
  plain: 1
}

SEPARATOR = '/'.freeze
def flatten_keys(hash)
  paths = hash.keys
  res = {}

  while paths.any?
    path = paths.pop
    val = hash.dig(*path)

    if val.is_a?(Hash)
      val.each_pair do |k,v|
        paths << [path,k].flatten
      end
    else
      new_key = path.is_a?(Array) ? path.map(&:to_s).join(SEPARATOR) : path
      res[new_key] = val
    end
  end

  res
end

def flatten_keys_2(hash)
  paths = hash.keys.map(&:to_s)
  res = {}

  while paths.any?
    current_path = paths.shift
    current_ary_path = current_path.split(SEPARATOR).map(&:to_sym)

    current = hash.dig(*current_ary_path)
    if current.is_a?(Hash)
      # build the new paths by appeding /key for each key
      new_paths = current.keys.map { |k| "#{current_path}#{SEPARATOR}#{k}" }
      paths.concat(new_paths)
    else
      res[current_path.to_sym] = current
    end
  end

  res
end

def flatten_keys_r(hash)
  hash.reduce({}) do |h, (k, v)|
    if !v.is_a?(Hash)
      h[k] = v
    else
      flatten_keys_r(v).each_pair do |sub_k, sub_v|
        h["#{k}#{SEPARATOR}#{sub_k}"] = sub_v
      end
    end

    h
  end
end

p hash, flatten_keys(hash), flatten_keys_2(hash), flatten_keys_r(hash)
