module ApplicationHelper

  def logo
    image_tag("kara.png", :alt => "Kara App", 
     :class => "round kara karaReflect")
  end
  def title
    base_title = "Kara Application"
    if @title.nil? 
	base_title
    else
	"#{base_title} | #{@title}"
    end
  end
end
