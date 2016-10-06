%inline %{
typedef std::vector<cv::Point> Points;
typedef std::vector<Points> VectorPoints;
%}


%inline %{

namespace cv {
   class KeyPoint;
}

typedef std::vector<cv::KeyPoint> KeyPoints;
%}
