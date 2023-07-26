def courses_data
  data = []
  Course.all.each do |course|
    if course.name_en.present?
      course_name = "#{course.name_en}"
      if course.lessons.present?
        course.lessons.each do |lesson|
          if lesson.name_en.present?
            course_name += "\n#{lesson.name_en}"
          end
        end
        data << { "prompt": "#{course_name} ->", "completion": " #{course.id}"}
      else
        data << { "prompt": "#{course_name} ->", "completion": " #{course.id}"}
      end
    end
  end
  data
end