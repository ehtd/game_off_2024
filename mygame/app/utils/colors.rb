def hex_to_rgba(hex, alpha = 255)
  r = (hex >> 16) & 0xFF
  g = (hex >> 8) & 0xFF
  b = hex & 0xFF

  { r: r, g: g, b: b, a: alpha }
end
