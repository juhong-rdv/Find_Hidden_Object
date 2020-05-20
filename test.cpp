#include "opencv2/opencv.hpp"

int main(void)
{
	//read image
	cv::Mat img = cv::imread("./img/find2.png") ;
	cv::Mat tpl = cv::imread("./img/fish.png") ;

	//bgr to gray
	cv::Mat img_gray ;
	cv::cvtColor(img, img_gray, cv::COLOR_BGR2GRAY) ;

	cv::Mat tpl_gray ;
	cv::cvtColor(tpl, tpl_gray, cv::COLOR_BGR2GRAY) ;

	//inverse	
	img_gray = 255 - img_gray ;
	tpl_gray = 255 - tpl_gray ;
	
	/// Create the result matrix
	int result_cols =  img_gray.cols - tpl_gray.cols + 1;
	int result_rows = img_gray.rows - tpl_gray.rows + 1;

	cv::Mat result ;
	result.create( result_cols, result_rows, CV_32FC1 );

	/// Do the img and Normalize
	cv::matchTemplate( img_gray, tpl_gray, result, cv::TM_SQDIFF, tpl_gray );

	/// Localizing the best match with minMaxLoc
	double minVal; double maxVal; cv::Point minLoc; cv::Point maxLoc;
	cv::Point matchLoc;

	cv::minMaxLoc( result, &minVal, &maxVal, &minLoc, &maxLoc, cv::Mat() );

	matchLoc = minLoc;

	/// Show me what you got
	cv::normalize( result, result, 0, 255, cv::NORM_MINMAX, -1, cv::Mat() );
	
	cv::rectangle( img, matchLoc, cv::Point( matchLoc.x + tpl.cols , matchLoc.y + tpl.rows ), cv::Scalar(0,0,255), 2, 8, 0 );

	cv::imwrite( "result.png", img );
	cv::imwrite( "result2.png", result );

	return 0 ;
}
