require 'rvg/rvg'

module ModelImage
  def detect_faces(url, size)
    detector = Faraday.new(url: ENV['FACE_DETECT_API_ENDPOINT']) do |faraday|
      faraday.adapter :net_http
    end
    data = JSON.parse(detector.get('/api', url: url).body)
    return if data['error']

    faces = data['faces']
    faces.each do |face|
      face['w'] *= 1.2
      face['h'] *= 1.2
    end
    faces.select do |face|
      face['w'] < 100 && face['h'] < 100 &&
        (face['w'] * data['image']['width'] / 100.0 > size / 2 &&
                                                             face['h'] * data['image']['height'] / 100.0 > size / 2)
    end
  end

  def face_image(img, face, size)
    eyes = face['eyes']
    eye_l, eye_r = eyes[0]['x'] < eyes[1]['x'] ? [eyes[0], eyes[1]] : [eyes[1], eyes[0]]
    rad = Math.atan2((eye_r['y'] - eye_l['y']) * img.rows, (eye_r['x'] - eye_l['x']) * img.columns)
    rvg = Magick::RVG.new(size, size) do |canvas|
      scale = size / [face['w'] * img.columns / 100.0, face['h'] * img.rows / 100.0].max
      canvas
        .image(img)
        .translate(size * 0.5, size * 0.5)
        .scale(scale)
        .rotate(-rad * 180.0 / Math::PI)
        .translate(-face['center']['x'] * img.columns / 100.0, -face['center']['y'] * img.rows / 100.0)
    end
    rvg.draw.to_blob { self.format = 'JPG' }
  end
end