
loadAvailability = function (idList, attemptCount) {
  idList = "991036860006003811"
  const url = $('#alma_availability_url').data('url') + "?id_list=" + encodeURIComponent(idList);
    fetch(url)
      .then(function(data) {
        console.log(data);
      })
    // if(idList.length > 0) {
    //     console.log(url);
    //     $.ajax(url, {
    //         success: function(data, textStatus, jqXHR) {
    //             if(!data.error) {
    //                 baObj.availability = Object.assign(baObj.availability, data['availability']);
    //                 baObj.populateAvailability();
    //             } else {
    //                 console.log("Attempt #" + attemptCount + " error loading availability for " + idList);
    //                 console.log(data.error);
    //
    //                 if(attemptCount < baObj.MAX_AJAX_ATTEMPTS) {
    //
    //                     if(data.error !== null && typeof data.error === 'object') {
    //                         if(data.error['error'] && data.error['error']['errorMessage']) {
    //                             var msg = data.error['error']['errorMessage'];
    //                             var isSingleId = idList.indexOf(",") === -1;
    //                             // this happens when an MMS ID has been deleted in Alma but Discovery hasn't caught up yet
    //                             if(msg.indexOf("Input parameters") !== -1 && msg.indexOf("is not valid.") !== -1 && !isSingleId) {
    //                                 console.log("Invalid MMS ID error from API, retrying batch as individual requests");
    //                                 idList.split(",").forEach(function(id) {
    //                                     baObj.availabilityRequestsFinished[id] = false;
    //                                     baObj.loadAvailabilityAjax(id, baObj.MAX_AJAX_ATTEMPTS);
    //                                 });
    //                             } else {
    //                                 baObj.errorLoadingAvailability(idList);
    //                             }
    //                         }
    //                     } else {
    //                         baObj.loadAvailabilityAjax(idList, attemptCount + 1);
    //                     }
    //
    //                 } else {
    //                     baObj.errorLoadingAvailability(idList);
    //                 }
    //             }
    //         },
    //         error: function(jqXHR, textStatus, errorThrown) {
    //             console.log("Attempt #" + attemptCount + " error loading availability: " + textStatus + ", " + errorThrown);
    //             if(errorThrown !== 'timeout') {
    //                 if(attemptCount < baObj.MAX_AJAX_ATTEMPTS) {
    //                     baObj.loadAvailabilityAjax(idList, attemptCount + 1);
    //                 } else {
    //                     baObj.errorLoadingAvailability(idList);
    //                 }
    //             }
    //         },
    //         complete: function() {
    //             baObj.showElementsOnAvailabilityLoad();
    //
    //             baObj.availabilityRequestsFinished[idList] = true;
    //         }
    //     });
    // }
};

loadAvailability();
