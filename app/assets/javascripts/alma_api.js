// Actually makes the AJAX call for availability
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

// Partitions an array into arrays of specified size
const partitionArray = (size, arr) => {
  return arr.reduce(function(acc, a, b) {
    if(b % size == 0  && b !== 0) {
      acc.push([]);
    }
    acc[acc.length - 1].push(a);
    return acc;
  }, [[]]);
};

/**
 * Looks for elements with class blacklight-availabililty, batches up the values in their data-availability-id attribute,
 * makes the AJAX request, and replaces the contents of the element with availability information.
*/
const loadAvailability = () => {
  let elementIds = Array.prototype.slice.call(document.getElementsByClassName("blacklight-availability"));
  const allIds = elementIds.map(element => {
    return $(element).data("availabilityIds");
  });

  let idArrays = partitionArray(10, allIds);

  idArrays.forEach(idArray => {
    let idArrayStr = idArray.join(",");
    loadAvailabilityAjax(idArrayStr, 1);
  });
};

// Checks for all AJAX availability requests, then displays messages for records that we couldn't load availability info for.
const checkAndPopulateMissing = () => {
  let availabilityIds = Array.prototype.slice.call(document.getElementsByClassName("blacklight-availability"));
  availabilityIds.filter(element => {
    document.querySelector("span:not(.blacklight-availability)")
    noHoldingsAvailabilityButton($(element).data("availabilityIds"));
    $(element).html("<span style='color: red'>No status available for this item</span>");
  })
};
