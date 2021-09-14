class TableOut extends Output{
    constructor(tableId) {
        super();
        this.tableId = tableId;
    }
    printItem(company){
        let tableId = "#" + this.tableId;
        let content = `<tr>
            <td scope="row" class="companyName">${company.companyJSON.content}</td>
            <th scope="col">
                <button type="button" class="btn btn-danger removeOnClick">Delete</button>
            </th>
            <th scope="col">
                <button type="button" class="btn btn-success viewClick">View</button>
            </th>
        </tr>`
        $(tableId).prepend(content)
        console.log("Printing")
    }
    removeItem(company){}
}