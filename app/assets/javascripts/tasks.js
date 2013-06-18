
// jquery code for lists/show.html.erb page....which shows tasks for a spcfic list...and also a form to add a new task
jQuery.fn.submitOnCheck= function()
{
    $(this).find('input[type=submit]').remove();
    $(this).find('input[type=checkbox]').click(function() {
        $(this).closest('form').submit();
    });
    return $(this);        // why should I return this ? ...and why has ryan bates used "this" instead of $(this) ?
}




$(function () {             /*This is same as $(document).ready()...also something to do with not conflicting with $ objects of other frameworks...dunno what that means ...should cjheck it out*/

    $('.edit_task').submitOnCheck();

});