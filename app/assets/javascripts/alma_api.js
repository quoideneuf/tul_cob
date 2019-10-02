// Checks whether availaiblity has been generated yet, and adds/removes classes based on available status
let availabilityButton = (id, holding) => {
  let availButton = document.querySelector("button[data-availability-ids='" + id + "']");

  if (!availButton.classList.contains("btn-success")) {
    if(holding['availability'] == "available") {
      availButton.innerHTML = "<span class='avail-label available'>Available</span>";
      availButton.classList.remove("btn-default");
      availButton.classList.add("btn-success", "collapsed", "collapse-button", "available", "availability-btn");
    }
    else if(holding['availability'] == 'check_holdings') {
      availButton.innerHTML = "<span class='avail-label available'>Available</span>";
      availButton.classList.remove("btn-default");
      availButton.classList.add("btn-success", "collapsed", "collapse-button", "available", "availability-btn");
    }
    else {
      unavailableItems(id);
    }
  }
}

// Generates the button for unavailable items
let noHoldingsAvailabilityButton = (id) => {
  unavailableItems(id);
 }

 // Checks whether availaiblity has been generated yet, and adds/removes classes based on unavailable status
let unavailableItems = (id) => {
  let availButton = document.querySelector("button[data-availability-ids='" + id + "']");

  availButton.innerHTML = "<span class='avail-label not-available'>Not Available</span>";
  availButton.classList.remove("btn-default");
  availButton.classList.add("btn-warning", "collapsed", "collapse-button", "availability-btn");
}

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
    return {}
  }
}

// Returns availability only for physical items
let availStatusByLibrary = (holding) => {
  if (holding["inventory_type"] == "physical") {
    return availabilityInfo(holding);
  }
};

// Generates a sorted list of libraries where items are available
let availableHoldings = (holdings) => {
  let availHoldings = [];
  holdings.forEach(holding => {
    let physicalHolding = availStatusByLibrary(holding)
    let updatedAvailability = availabilityInfo(physicalHolding)
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

// Generates a sorted list of libraries where items have the check_holdings availability status
let checkHoldings = function (holdings) {
  let check = [];
  holdings.forEach(holding => {
    let physicalHolding = availStatusByLibrary(holding)
    let updatedAvailability = availabilityInfo(physicalHolding)
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

// Adds a sorted list of libraries for available/check_holdings to html
let libraryLists = (id, holdings) => {
  let html = ""
  let available = availableHoldings(holdings);
  let check = checkHoldings(holdings);
  let element = document.getElementById(`library-list-${id}`);

    if (available) {
      element.innerHTML = "<dt class='index-label col-md-4 col-lg-3' >Available at: </dt><dd class='col-md-5 col-lg-7'>" + available + "</dd>";
    }

    if (check) {
      element.innerHTML += "<dt class='index-label col-md-4 col-lg-3' >Other Libraries: </dt><dd class='col-md-5 col-lg-7'>" + check + "</dd>";
    }
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
    if(!data.error) {
      Object.keys(data).forEach(id => {
        let holdings = data[id]["holdings"] || [];
        if (holdings.length > 0) {
          holdings.map(holding => {
            availabilityButton(id, holding);
            return availStatusByLibrary(holding);
          })
          return libraryLists(id, holdings);
        } else {
          noHoldingsAvailabilityButton(id);
        }
      })
    }
    // } else {
    //   console.log("test")
    // }
  })
  .catch(error => console.log(error));
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
