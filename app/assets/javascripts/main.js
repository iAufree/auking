(function($) {
    var Forum = {

        init: function() {
            var self = this;
            var BootUp = function() {
                self.siteBootUp();
            }
            $(document).on("page:update", BootUp);
        },

        /*
         * Things to be execute when normal page load
         * and pjax page load.
         */
        siteBootUp: function() {
            var self = this;
            self.initEmoji();
            self.initAutocompleteAtUser();
            self.initWarning();
            self.initToggle();
            self.initInsert();
            self.initBootstrap();
            self.initAnimate();
            self.initInsert();
            self.initMarkdownView();
            self.initSelectImage();
        },

        /**
         * Enable emoji everywhere.
         */
        initEmoji: function() {
            emojify.setConfig({
                img_dir: '/images/emoji',
                ignored_tags: {
                    'SCRIPT': 1,
                    'TEXTAREA': 1,
                    'A': 1,
                    'PRE': 1,
                    'CODE': 1
                }
            });
            emojify.run();

            $('textarea').textcomplete([{ // emoji strategy
                match: /\B:([\-+\w]*)$/,
                search: function(term, callback) {
                    callback($.map(emojies, function(emoji) {
                        return emoji.indexOf(term) === 0 ? emoji : null;
                    }));
                },
                template: function(value) {
                    return '<img src="/images/emoji/' + value + '.png"></img>' + value;
                },
                replace: function(value) {
                    return ':' + value + ': ';
                },
                index: 1,
                maxCount: 5
            }]);
        },

        /**
         *  Autocomplete @user
         **/
        initAutocompleteAtUser: function() {
            var at_users = [],
                user;
            $users = $('.commenter');
            for (var i = 0; i < $users.length; i++) {
                user = $users.eq(i).html();
                if ($.inArray(user, at_users) == -1) {
                    at_users.push(user);
                };
            };

            $('textarea').textcomplete([{
                mentions: at_users,
                match: /\B@(\w*)$/,
                search: function(term, callback) {
                    callback($.map(this.mentions, function(mention) {
                        return mention.indexOf(term) === 0 ? mention : null;
                    }));
                },
                index: 1,
                replace: function(mention) {
                    return '@' + mention + ' ';
                }
            }], {
                appendTo: 'body'
            });

            $reply = $('.reply-user');
            $reply.click(function() {
                name = '@' + $(this).attr('data-name') + ' ';
                $('textarea').val($('textarea').val() + name);
                $('textarea').focus();
            });

        },

        /**
         * Comment Warning
         */
        initWarning: function() {
            $('.comment-submit').click(function(event) {
                if ($('textarea').val() === "") {
                    $('.comment-warning').css("display", "block").addClass('animated shake');
                    $('textarea').focus();
                }
            });
        },

        /**
         * Form Toggle
         */
        initToggle: function() {
            $('#toggle-sign').click(function() {
                $('#cool-form').toggle();
            });
        },

        /**
         * Markdown insert image
         **/
        initInsert: function() {
            $('.upload-file').click(function() {
                $txtval = $('textarea').val();
            }).change(
                function() {
                    $textarea = $('textarea');
                    $.each(event.target.files, function() {
                        var after, before, fileName, formData, imageTag, pos;
                        formData = new FormData();
                        formData.append('attachment[file]', this);
                        fileName = this.name;
                        imageTag = "![" + fileName + "]()";
                        pos = $textarea[0].selectionStart;
                        before = $textarea.val().slice(0, pos);
                        after = $textarea.val().slice(pos, -1);
                        if (before !== '') {
                            before = before + "\n";
                        }
                        if (after !== '') {
                            after = "\n" + after;
                        }
                        $textarea.val(before + imageTag + after);
                        $textarea[0].selectionStart = (before + imageTag).length;
                        return $.ajax({
                            url: '/attachments',
                            type: 'POST',
                            dataType: 'json',
                            processData: false,
                            contentType: false,
                            data: formData,
                            success: function(data) {
                                var imagePos;
                                pos = $textarea[0].selectionStart;
                                imagePos = $textarea.val().indexOf(imageTag);
                                $textarea.val($textarea.val().replace(imageTag, "![" + fileName + "](" + data.url + ")"));
                                if (imagePos < pos) {
                                    return $textarea[0].selectionStart = $textarea[0].selectionEnd = pos + data.url.length;
                                } else {
                                    return $textarea[0].selectionStart = $textarea[0].selectionEnd = pos;
                                }
                            }
                        });
                    });
                    return $(this).replaceWith($(this).val('').clone());
                });
        },

        /**
         * Call Bootstrap Plugin
         **/
        initBootstrap: function() {
            $('#user-tab a').click(function(e) {
                e.preventDefault();
                $(this).tab('show');
            });
            $('.navbar li').click(function(e) {
                $('.navbar li.active').removeClass('active');
                var $this = $(this);
                if (!$this.hasClass('active')) {
                    $this.addClass('active');
                }
            });
        },

        /**
         * Call Animate.css
         **/
        initAnimate: function() {
            var element = [".row"];
            var effect = ["fadeIn"];
            for (var i = 0; i < element.length; i++) {
                $(element[i]).addClass("animated " + effect[i] + "");
            };
        },

        /**
         *  Select Image
         **/
        initSelectImage: function() {
            $('.select-picture').find('i').click(function() {
                $('input#comment_file').click();
            });
        },

        /**
         *  Markdown preview
         **/
        initMarkdownView: function() {
            $preview = $('#preview');
            $markdown = $('#markdown');
            $markdown.click(function() {
                $preview.html("");
                $.ajax({
                    type: 'POST',
                    url: '/markdown/preview',
                    data: {
                        body: $('textarea').val()
                    },
                    success: function(data) {
                        $preview.html(data);
                        return $preview.css({
                            height: 'auto'
                        });
                    }
                });
            });
        },

        /**
         *  LightBox
         **/
        initLightBox: function() {
            $(document).delegate('.comment-body img:not(.emoji)', 'click', function(event) {
                event.preventDefault();
                return $(this).ekkoLightbox({
                    onShown: function() {
                        if (window.console) {}
                    }
                });
            });
        },
    }
    window.Forum = Forum;
})(jQuery);

$(document).ready(function() {
    Forum.init();
    Forum.initLightBox();
});
