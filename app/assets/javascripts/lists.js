
   var showEmptyListsMessage= function(){
       console.log($('ul.lists div').length);
       if($('ul.lists div').length > 1)      // If the nmbr of lists becomes zero , we show a message...else we hide the message
           $('#lists_empty').hide();
       else
           $('#lists_empty').show();
   };

    $('.new_list input[type=submit]').click(function() {
       $(this).closest('form').submit();
    })  ;



   $(function () {             /*This is same as $(document).ready()...also something to do with not conflicting with $ objects of other frameworks...dunno what that means ...should cjheck it out*/

      showEmptyListsMessage();
           $(document).delegate(document,"ajaxSuccess",function(){
              showEmptyListsMessage();
       });

   });

