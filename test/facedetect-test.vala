
using Gee;

public class FaceDetectTest : Object {
	
	const string SOURCES_PATH = "./sources/";
	const string IMAGES_FACES_DETECTED_OUTPUT_PATH = "./detected_faces/";
	
	[CCode (array_length = false, array_null_terminated = true)]
	private static string[] cascades;
	[CCode (array_length = false, array_null_terminated = true)]
	private static string[] scales_option;
	private static Gee.List<double?> scales;
	private static bool export_faces = false;
	
	const OptionEntry[] entries = {
		{
			"cascade",
			'c',
			0,
			OptionArg.FILENAME_ARRAY,
			ref cascades,
			"Cascade file to use. Specify it more than one time to perform one test per cascade file.",
			"<cascade_path>"
		},
		{
			"scale",
			's',
			0,
			OptionArg.STRING_ARRAY,
			ref scales_option,
			"Scale to use. Specify it more than one time to perform one test per scale per cascade file.",
			"<image scale>"
		},
		{
			"export-faces",
			'e',
			0,
			OptionArg.NONE,
			ref export_faces,
			"If used, the program will export detected faces as image files.",
			null
		},
		{null}
	};
	
	public static int main(string[] args) {
		
		try {
			
			OptionContext context = new OptionContext("");
			context.add_main_entries(entries, null);
			context.parse(ref args);
			
		} catch (OptionError e) {
			
			stdout.printf ("%s\n", e.message);
			stdout.printf ("Run '%s --help' to see a full list of available command line options.\n", args[0]);
			return -1;
			
		}
		
		if (cascades.length == 0) {
			
			stdout.printf ("You must specify at least one cascade file.\n");
			return -1;
			
		}
		
		if (scales_option.length == 0) {
			
			stdout.printf ("You must specify at least one scale value.\n");
			return -1;
			
		}
		
		scales = new ArrayList<double?>();
		foreach (string scale in scales_option) {
			
			double? temp = double.parse(scale);
			
			if (temp < 1) {
				
				stdout.printf ("Scale values must be greater or equal to 1.\n");
				return -1;
				
			}
			
			scales.add(temp);
			
		}
		
		foreach (string cascade in cascades) {
			
			foreach (double scale in scales) {
				
				test(cascade, scale);
				
			}
			
		}
		
		return 0;
		
	}
	
	private static void test(string cascade, double scale) {
		
		string command = "../facedetect --cascade=\"" + cascade + "\" --scale=\"" + scale.to_string() + "\" \"";
		
		string[] cascade_name_pieces = cascade.split("/");
		string cascade_name = cascade_name_pieces[cascade_name_pieces.length - 1];
		
		File test_images_folder = File.new_for_path(SOURCES_PATH);
		
		FileEnumerator enumerator = test_images_folder.enumerate_children(FileAttribute.STANDARD_NAME, 0);
		
		for (FileInfo file_info = enumerator.next_file(); file_info != null; file_info = enumerator.next_file()) {
			
			stdout.printf ("%s\n", file_info.get_name());
			
			string file_name = file_info.get_name();
			string file_path = SOURCES_PATH + file_name;
			string output;
			bool success = Process.spawn_command_line_sync(command + file_path + "\"", out output);
			
			Gee.List<FaceInfo> faces = new ArrayList<FaceInfo>();
			string[] lines = output.split("\n");
			foreach (string line in lines) {
				
				if (line.length == 0)
					continue;
				
				string[] pieces = line.split(";");
				if (pieces.length != 2)
					throw new FaceInfoError.PARSE_ERROR("Wrong serialized.");
				
				switch (pieces[0]) {
					
					case "face":
						faces.add(FaceInfo.parse(pieces[1]));
						break;
					
					case "warning":
						stderr.printf("%s\n", pieces[1]);
						break;
					
					case "error":
						stderr.printf("%s\n", pieces[1]);
						assert_not_reached();
					
					default:
						assert_not_reached();
					
				}
				
			}
			
			Gdk.Pixbuf pixbuf = new Gdk.Pixbuf.from_file(file_path);
			Cairo.ImageSurface surface =
				new Cairo.ImageSurface(Cairo.Format.ARGB32, pixbuf.get_width(), pixbuf.get_height());
			Cairo.Context context = new Cairo.Context(surface);
			Gdk.cairo_set_source_pixbuf(context, pixbuf, 0, 0);
			context.paint();
			
			context.set_source_rgb(255, 0, 0);
			context.set_line_width(2);
			
			if (export_faces) {
				
				Process.spawn_command_line_sync("mkdir -p \"" + IMAGES_FACES_DETECTED_OUTPUT_PATH + cascade_name + "/" + scale.to_string() +  "/faces/\"");
				
			}
			
			int c = 0;
			foreach (FaceInfo face in faces) {
				
				if (export_faces) {
					
					Cairo.Surface face_img = new Cairo.Surface.for_rectangle(
						surface,
						face.x * pixbuf.get_width(),
						face.y * pixbuf.get_height(),
						face.width * pixbuf.get_width(),
						face.height * pixbuf.get_height()
					);
					face_img.write_to_png(IMAGES_FACES_DETECTED_OUTPUT_PATH + cascade_name + "/" + scale.to_string() +  "/faces/" + file_name + c.to_string() + ".png");
					
					c++;
					
				}
				
				context.rectangle(
					face.x * pixbuf.get_width(),
					face.y * pixbuf.get_height(),
					face.width * pixbuf.get_width(),
					face.height * pixbuf.get_height()
				);
				
			}
			
			context.stroke();
			
			Process.spawn_command_line_sync("mkdir -p \"" + IMAGES_FACES_DETECTED_OUTPUT_PATH + cascade_name + "/" + scale.to_string() +  "/\"");
			
			surface.write_to_png(IMAGES_FACES_DETECTED_OUTPUT_PATH + cascade_name + "/" + scale.to_string() +  "/" + file_name + ".png");
			
		}
		
	}
	
}

public errordomain FaceInfoError {
	
	PARSE_ERROR
	
}

public class FaceInfo {
	
	public double x;
	public double y;
	public double width;
	public double height;
	
	public FaceInfo (double x, double y, double width, double height) {
		
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		
	}
	
	public static FaceInfo parse (string serialized) {
		
		string[] pieces = serialized.split("&");
		if (pieces.length != 4)
			throw new FaceInfoError.PARSE_ERROR("Wrong serialized.");
		
		double x = 0;
		double y = 0;
		double width = 0;
		double height = 0;
		
		foreach (string piece in pieces) {
			
			string[] name_and_value = piece.split("=");
			if (name_and_value.length != 2)
				throw new FaceInfoError.PARSE_ERROR("Wrong serialized.");
			
			switch (name_and_value[0]) {
				
				case "x":
					x = double.parse(name_and_value[1]);
					break;
				
				case "y":
					y = double.parse(name_and_value[1]);
					break;
				
				case "width":
					width = double.parse(name_and_value[1]);
					break;
				
				case "height":
					height = double.parse(name_and_value[1]);
					break;
				
				default:
					throw new FaceInfoError.PARSE_ERROR("Wrong serialized.");
				
			}
			
		}
		
		return new FaceInfo(x, y, width, height);
		
	}
	
}