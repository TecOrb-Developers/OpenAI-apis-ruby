def courses_data
  data = []
  Course.all.each do |course|
    if course.name_es.present?
      course_data = {
        "id" => course.id,
        "title" => course.name_es,
        "lessons" => []
      }
      if course.lessons.present?
        course.lessons.each do |lesson|
          if lesson.name_en.present?
            course_data["lessons"] << {
              "id" => lesson.id,
              "title" => lesson.name_es
            }
          end
        end
      end
      if course_data["lessons"].present?
        data << course_data
      end
    end
  end
  data
end