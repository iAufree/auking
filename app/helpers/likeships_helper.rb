module LikeshipsHelper
  def likeable_likes_tag like
    @like = Object.const_get(like[:likeable_type]).where(id: like[:likeable_id]).first
    if @like.likeships.count > 0
      likes_count = @like.likeships.count
    else
      likes_count = ''
    end
    return "#{likes_count} #{fa_icon}".html_safe if current_user.blank?

    if current_user and current_user.liking?(like)
      class_name = "red gray"
      link_title = "unlike"
      link_path_method = "delete"
      fa_icon = fa_icon('heart')
    else
      class_name = "gray"
      link_title = "like"
      link_path_method = "post"
      fa_icon = fa_icon('heart-o')
    end
    link_to "#{likes_count} #{fa_icon}".html_safe, likeship_path(like), class: class_name, title: link_title, method: link_path_method, remote: true
  end
end