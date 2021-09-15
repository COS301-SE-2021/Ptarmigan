class TableOut extends Output{
    constructor(tableId) {
        super();
        this.tableId = tableId;
    }
    printItem(company){
        let tableId = "#" + this.tableId;
        let content = `<tr id="${company.companyJSON.content}">
            <td scope="row" class="companyName" >${company.companyJSON.content}</td>
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
    removeItem(company){
        let rowId = "#" + company.companyJSON.content;
        console.log(company.companyJSON.content)
        $(rowId).remove()

        // console.log(location)

        // location.parent().remove()

    }

    viewSingleCompany(company){
        console.log("Viewing single company")
    }
}