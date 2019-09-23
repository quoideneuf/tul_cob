// First checks for libraries with available items, then libraries with check_holdings status
let availabilityInfo = (holding) => {
  let library = holding["library"];
  let availability = holding["availability"];
  // ASRS items should display as being at Charles Library
  if (library == "ASRS" || library == "Paley Library") {
    library = "Charles Library";
  } else {
    library = holding["library"];
  }

  if (library != "EMPTY") {
    if (availability == "available") {
      let availItem = {};
      availItem = Object.assign(availItem, {library, availability})
      return availItem;
    }

    if (availability == "check_holdings") {
      let checkItem = {};
      checkItem = Object.assign(checkItem, {library, availability})
      return checkItem;
    }
  }
}

// Returns a hash with library name and availability status
let availStatusByLibrary = (holding) => {
  if (holding["inventory_type"] == "physical") {
    return availabilityInfo(holding);
  }
};

let availableHoldings = (holdings) => {
  let availHoldings = [];
  holdings.forEach(holding => {
    let updatedAvailability = availabilityInfo(holding)
    if (updatedAvailability["availability"] == "available") {

      availHoldings.push(updatedAvailability["library"]);
      availHoldings.sort();

      if (availHoldings.indexOf("Charles Library") > 0) {
          availHoldings.splice(holdings.indexOf("Charles Library"), 1);
          availHoldings.unshift("Charles Library");
      }
    }
    return availHoldings;
  });

  let list = [... new Set(availHoldings)]
  console.log("avail: " + list)
  return list.join("<br/>");
}

let checkHoldings = function (holdings) {
  let check = [];
  holdings.forEach(holding => {
    let updatedAvailability = availabilityInfo(holding)
    if (updatedAvailability["availability"] == "check_holdings") {
      check.push(updatedAvailability["library"]);
      check.sort();

      if (check.indexOf("Charles Library") > 0) {
          check.splice(holdings.indexOf("Charles Library"), 1);
          check.unshift("Charles Library");
      }
    }
  });

  let list = [... new Set(check)]
  console.log("check: " + list)
  return list.join("<br/>");
}

let libraryLists = (holdings) => {
  let html = ""
  let available = availableHoldings(holdings);
  let check = checkHoldings(holdings);
  let elementIds = Array.prototype.slice.call(document.getElementsByClassName("blacklight-availability"));

  elementIds.forEach(html => {
    if (available) {
      html.innerHTML = "<dt class='index-label col-md-4 col-lg-3' >Available at: </dt><dd class='col-md-5 col-lg-7'>" + available + "</dd>";
    }

    if (check) {
      html.innerHTML += "<dt class='index-label col-md-4 col-lg-3' >Other Libraries: </dt><dd class='col-md-5 col-lg-7'>" + check + "</dd>";
    }
  });
};

// Actually makes the AJAX call for availability
const loadAvailabilityAjax = (idList, attemptCount) => {
  const dataUrl = document.getElementById("alma_availability_url")
  const url = dataUrl.dataset.url + "?id_list=" + encodeURIComponent(idList);
  fetch(url, {
    method: "GET",
    headers:{
      "Content-Type": "application/json"
    }
  })
  .then(res => res.json())
  .then(function(data) {
    Object.keys(data).forEach(id => {
      let holdings = data[id]["holdings"];
      if (holdings.length > 0) {
        let formatted = holdings.filter(holding => {
          // availabilityButton(id, holding);
          return availStatusByLibrary(holding);
        })
        return libraryLists(formatted);
      } else {
        // noHoldingsAvailabilityButton(id);
      }
    });
  })
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

// Batches the data-availability-ids, makes the AJAX request, and replaces the contents of the element with availability information.
loadAvailability = () => {
  let elementIds = Array.prototype.slice.call(document.getElementsByClassName("blacklight-availability"));
  const allIds = elementIds.map(element => {
    return element.dataset.availabilityIds;
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
    document.querySelector("dl:not(.blacklight-availability)")
    // Can I do this here?  Or does it need to be in another function chained to this one?
    noHoldingsAvailabilityButton(element.dataset.availabilityIds);
    element.innerHTML += "<span style='color: red'>No status available for this item</span>";
  })
};
