class TableCSV {
  constructor(tableId) {
    this.tableTarget = document.querySelector(tableId);

    if (!this.tableTarget) {
      throw Error("table not found ");
    }
  }

  download() {
      const csvFile = new Blob([this.csv()], { type: 'text/csv' })
      const downloadLink =  document.createElement('a')
      // sets the name for the download file
      downloadLink.download = "players.csv"
      // sets the url to the window URL created from csv file above
      downloadLink.href = window.URL.createObjectURL(csvFile)
      // creates link, but does not display it.
      downloadLink.style.display = 'none'
      // add link to body so click function below works
      document.body.appendChild(downloadLink)
      downloadLink.click()
  }

  csv() {
    return [
      this.headers(),
      ...this.rows()
    ].map(row => row.join(',')).join("\n");
  }

  headers() {
    const th = this.tableTarget.querySelectorAll('th');
    return Array.from(th).map(e => e.innerText);
  }

  rows() {
    const rows = this.tableTarget.querySelectorAll('tbody > tr');
    return Array.from(rows).map(e => Array.from(e.querySelectorAll('td')).map(e => e.innerText));
  }
}

export default TableCSV;
