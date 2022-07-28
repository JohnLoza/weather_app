document.addEventListener('DOMContentLoaded', captureFormSubmit, false);

function setLoading(loading) {
  const container = document.querySelector('.pronostic-results');
  let html = ''
  if (loading)
    html = '<p class="lead">Cargando...</p>';
  container.innerHTML = html;
}

function updateUi(data) {
  console.log('response: ', data.data);
  setLoading(false);
  const container = document.querySelector('.pronostic-results');
  if (data.success) {
    for (let place of data.data)
      container.innerHTML += pronosticTemplate(place);
  } else {
    alert(`Ocurrió un error: ${data.error}`);
  }
}

function fetchPronostics(query) {
  setLoading(true);
  fetch(`http://localhost:3000/api/v1/pronostics/search?query=${query}`)
    .then(response => response.json())
    .then(data => updateUi(data));
}

function processForm(evnt) {
  evnt.preventDefault();
  const queryInput = evnt.currentTarget.querySelector('#pronostic_query');
  fetchPronostics(queryInput.value);
}

function captureFormSubmit () {
  const form = document.querySelector('.pronostics-search-form');
  if (!form) return;

  if (form.attachEvent) {
    form.attachEvent("submit", processForm);
  } else {
    form.addEventListener("submit", processForm);
  }
}
