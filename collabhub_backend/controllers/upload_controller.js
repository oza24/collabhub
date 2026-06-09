const cloudinary =
require("../config/cloudinary");

exports.uploadAvatar =async (req,res)=>{
  try{
    console.log("UPLOAD HIT");
    console.log("FILE:");
    console.log(req.file);
    const file =req.file;
    const result =
      await new Promise(
        (resolve,reject)=>{
          cloudinary.uploader
            .upload_stream(
              {
                folder:
                  "collabhub/avatar",
              },

              (error,result)=>{

                if(error){
                  console.log(error);
                  reject(error);
                }

                else{
                  resolve(result);
                }
              }

            )
            .end(file.buffer);
        }
      );

    console.log(result);

    res.json({
      imageUrl:
        result.secure_url,
    });

  }catch(error){

    console.log("UPLOAD ERROR:");
    console.log(error);

    res.status(500).json({
      message:
        error.message,
    });

  }
};

exports.uploadChatFile = async (req, res) => {
    try {
      console.log("UPLOAD CHAT FILE HIT");

        console.log(req.file);
        console.log("step : 1:");
      const file = req.file;
        console.log("step : 2:");
      const result = await new Promise((resolve, reject) => {
          cloudinary.uploader.upload_stream(
            {
              folder: "collabhub/chat",
            },
            (error, result) => {
              if (error) {
                console.log(error);
                reject(error);
              } 
              else 
              {
                resolve(result);
              }
            }
          ).end(file.buffer);
        });
        console.log("STEP 3");

        console.log(result);

      res.json({
          fileUrl: result.secure_url,
          fileName: file.originalname,
      });
    }
    catch (error) {
      console.log("UPLOAD ERROR:");
      console.log(error);
      res.status(500).json({
          message: error.message,
      });
    }
  };