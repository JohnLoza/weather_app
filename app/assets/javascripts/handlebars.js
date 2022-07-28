function pronosticTemplate(data) {
  const template =
    Handlebars.compile(`
      <div class="col-lg-4 col-md-6 col-12">
        <p class="strong lead">{{city}}, {{state}}, {{country}}</p>
        {{#each daily}}
          <p>{{date}}, temperature {{this.min}}°~{{this.max}}°</p>
        {{/each}}
      </div>
    `);
  return template(data);
}
