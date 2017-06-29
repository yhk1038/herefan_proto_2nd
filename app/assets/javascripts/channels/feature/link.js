// $(document).ready(function () {
//
// });

function report_alert(link_id, user_id) {
    var title = $('#link_'+link_id).find('.linkcard-title').text();
    var req = $.ajax({
        url: '/reports.json',
        method: 'post',
        data: {
            authenticity_token: _hf_,
            report: {
                user_id: user_id,
                link_id: link_id
            }
        }
    });

    req.done(function (data) {

        swal('Report','Your report is completed. ([#'+data.id+'] '+ title +')','success');
    });

    // SWEET-ALERT EXAMPLE CODE
    //
    // swal({
    //     title: 'Submit email to run ajax request',
    //     input: 'text',
    //     showCancelButton: true,
    //     confirmButtonText: 'Submit',
    //     showLoaderOnConfirm: true,
    //     preConfirm: function (email) {
    //         return new Promise(function (resolve, reject) {
    //             setTimeout(function() {
    //                 if (email === 'taken@example.com') {
    //                     reject('This email is already taken.')
    //                 } else {
    //                     resolve()
    //                 }
    //             }, 2000)
    //         })
    //     },
    //     allowOutsideClick: false
    // }).then(function (email) {
    //     swal({
    //         type: 'success',
    //         title: 'Ajax request finished!',
    //         html: 'Submitted email: ' + email
    //     })
    // });

    return false
}