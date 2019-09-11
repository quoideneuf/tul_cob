
const loadAvailabilityAjax = (idList, attemptCount) => {
  const url = $("#alma_availability_url").data("url") + "?id_list=" + encodeURIComponent(idList);
  fetch(url, {
    method: "GET",
    headers:{
      "Content-Type": "application/json"
    }
  })
  .then(res => res.json())
  .then(response => console.log("Success:", JSON.stringify(response)))
  .catch(error => console.error("Error:", error));
};

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


loadAvailabilityAjax();

partitionArray = function(size, arr) {
  return arr.reduce(function(acc, a, b) {
    if(b % size == 0  && b !== 0) {
      acc.push([]);
    }
    acc[acc.length - 1].push(a);
    return acc;
  }, [[]]);
};

/**
 * Looks for elements with class availability-ajax-load,
 * batches up the values in their data-availability-id attribute,
 * makes the AJAX request, and replaces the contents
 * of the element with availability information.
 */
loadAllAvailability = function() {
  let allIds = $(".blacklight-availability").map(function (index, element) {
    return $(element).data("availabilityIds");
  }).get();

  var idArrays = partitionArray(10, allIds);

  idArrays.forEach(function(idArray) {
    var idArrayStr = idArray.join(",");
    console.log("test")
    console.log(idArrayStr);
    loadAvailabilityAjax(idArrayStr, 1);
  });
};

loadAllAvailability();
