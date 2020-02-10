
import Navi from "./Navi";
import 'bootstrap/dist/css/bootstrap.min.css';

export default function Layout(props) {
	return (
		<div>
			<Navi />
			{props.children}
		</div>
	);
}
