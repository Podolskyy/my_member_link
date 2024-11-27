<?php

include_once("dbconnect.php");

// Get the current page number and page size from the request
$pageno = isset($_GET['pageno']) ? (int)$_GET['pageno'] : 1;
$page_size = 5; // Change this to the number of news items per page
$offset = ($pageno - 1) * $page_size;

// Get the total number of results
$sqlcount = "SELECT COUNT(*) AS total FROM `tbl_news`";
$countresult = $conn->query($sqlcount);
$total = $countresult->fetch_assoc()['total'];
$numofpage = ceil($total / $page_size); // Calculate the number of pages

// Fetch the news for the current page
$sqlloadnews = "SELECT * FROM `tbl_news` ORDER BY `news_date` DESC LIMIT $offset, $page_size";
$result = $conn->query($sqlloadnews);

if ($result->num_rows > 0) {
    $newsarray['news'] = array();
    while ($row = $result->fetch_assoc()) {
        $news = array();
        $news['news_id'] = $row['news_id'];
        $news['news_title'] = $row['news_title'];
        $news['news_details'] = $row['news_details'];
        $news['news_date'] = $row['news_date'];
        array_push($newsarray['news'], $news);
    }
    $response = array(
        'status' => 'success',
        'data' => $newsarray,
        'numofpage' => $numofpage, // Total number of pages
        'numberofresult' => $total // Total number of results
    );
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>
