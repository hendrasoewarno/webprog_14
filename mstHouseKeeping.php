<?php
include("library.php");

function showUI() {
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>DataTables Example</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1"> 
  <link href="bootstrap-5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="bootstrap-5.3.2/dist/js/bootstrap.bundle.min.js"></script>	
  <script src="jquery/jquery-3.7.1.min.js"></script>  
  <link href="DataTables/datatables.min.css" rel="stylesheet"> 
  <script src="DataTables/datatables.min.js"></script>
</head>
<body>

<div class="container-fluid">
<p>
</p>
<table id="example" class="display" style="width:100%">
        <thead>
            <tr>
                <th>RoomId</th><th>Lantai</th><th>JenisKamar</th><th>Status</th><th>ReadyTime</th><th>Keterangan</th><th>Action</th>
            </tr>
        </thead>
</table>
</div>
<script>
$(document).ready(function () {
	$.get("SelectOptions.php?flag=JenisKamar",
	    	function(data,status) {	
				for (i=0; i<data.length; i++) {
					$('#JenisKamar').append('<option value="' + data[i].key + '">' + data[i].value + '</option>');
				}	
		}
	);
});
</script>
<script>
var flag="none";

var table = $('#example').DataTable( {
    serverSide: true,
    ajax: {
        url: '?flag=show',
		type: 'POST'
    },
	columns: [
        { data: 'RoomId' }, { data: 'Lantai' },  { data: 'JenisKamar' },  { data: 'Status' }, { data: 'ReadyTime' },  { data: 'Keterangan' },
		{ "orderable": false, "data": null,"defaultContent":
				"<button type=\"button\" class=\"btn btn-dark btn-sm\" id=\"ready\">Ready</button>"}
    ]
} );


function postToServer(obj, callBack) {
	$.post("?flag=" + flag,
		JSON.stringify(obj), 
	    	function(data,status) {
				if (data["status"]==1) {
					callBack();
				}
				else {
					$("#feedback").text(data["message"]);
				}
		}
	);
}

//klik pada button ready
table.on('click', '#ready', function (e) {
	//ambil data dari baris yang diklik
    var row = table.row(e.target.closest('tr')).data();
    var RoomId = row[0];
	var obj = {"RoomId":RoomId};
	$.post("?flag=ready", JSON.stringify(obj), 
	    function(data,status) {
			if (data["status"]==1) {
				table.ajax.reload();
			}
		}
	);
});
</script>
</body>
</html>
<?php
}
if (isset($_REQUEST["flag"])) {
	if ($_REQUEST["flag"]=="show") {
		$con = openConnection();

		//untuk hitung total baris
		$sqlCount = "SELECT count(*) FROM room;";

		//untuk mengembalikan data
		$length = intval($_REQUEST["length"]);
		$start = intval($_REQUEST["start"]);
		$sqlData = "SELECT RoomId, Lantai, JenisKamar, case when Status=1 Then 'Aktif' else 'Non-Aktif' end as Status, ReadyTime, Keterangan FROM room WHERE (RoomId LIKE :search or JenisKamar Like :search) LIMIT $length OFFSET $start";
		$data = array();
		$data["draw"]=intval($_REQUEST["draw"]);
		$data["recordsTotal"]=querySingleValue($con, $sqlCount, array());
		$param = array("search"=>$_REQUEST["search"]["value"]."%");
		$data["data"]=queryArrayRowsValues($con, $sqlData, $param);
		$data["recordsFiltered"]=sizeof($data["data"]);
		
		header("Content-type: application/json; charset=utf-8");
		echo json_encode($data);
	}
	else if($_REQUEST["flag"]=="ready") {
		$response=array();
		try {
			$con = openConnection();
			$body = file_get_contents('php://input');
			$data = json_decode($body, true);		
			$sql = "UPDATE room SET ReadyTime=now() WHERE RoomId=:RoomId;";		
			updateRow($con, $sql, array("RoomId"=>$data['RoomId']));
			$response["status"]=1;
			$response["message"]="Ok";
			$response["data"]=$data;
		}
		catch(Exception $e) {
			$response["status"]=0;
			$response["message"]=$e->getMessage();
			$response["data"]=null;						
		}
		
		header("Content-type: application/json; charset=utf-8");
		echo json_encode($response);
	}	
}
else {
	showUI();
}
?>
