module ApplicationHelper

  def base_title
    "Kara Application"
  end
  def logo
    image_tag("kara.png", :alt => "Kara App", 
     :class => "round kara karaReflect")
  end
  def title
    if @title.nil? 
	base_title
    else
	"#{base_title} | #{@title}"
    end
  end
end
